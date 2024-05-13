1 pragma solidity ^0.5.16;
2 
3 import "./CCapableErc20Delegate.sol";
4 import "../EIP20Interface.sol";
5 
6 /**
7  * @notice Compound's Comptroller interface to get Comp address
8  */
9 interface IComptroller {
10     function getCompAddress() external view returns (address);
11 
12     function claimComp(
13         address[] calldata holders,
14         CToken[] calldata cTokens,
15         bool borrowers,
16         bool suppliers
17     ) external;
18 }
19 
20 /**
21  * @title Cream's CCToken's Contract
22  * @notice CToken which wraps Compound's Ctoken
23  * @author Cream
24  */
25 contract CCTokenDelegate is CCapableErc20Delegate {
26     /**
27      * @notice The comptroller of Compound's CToken
28      */
29     address public underlyingComptroller;
30 
31     /**
32      * @notice Comp token address
33      */
34     address public comp;
35 
36     /**
37      * @notice Container for comp rewards state
38      * @member balance The balance of comp
39      * @member index The last updated index
40      */
41     struct RewardState {
42         uint256 balance;
43         uint256 index;
44     }
45 
46     /**
47      * @notice The state of Compound's CToken supply
48      */
49     RewardState public supplyState;
50 
51     /**
52      * @notice The index of every Compound's CToken supplier
53      */
54     mapping(address => uint256) public supplierState;
55 
56     /**
57      * @notice The comp amount of every user
58      */
59     mapping(address => uint256) public compUserAccrued;
60 
61     /**
62      * @notice Delegate interface to become the implementation
63      * @param data The encoded arguments for becoming
64      */
65     function _becomeImplementation(bytes memory data) public {
66         super._becomeImplementation(data);
67 
68         underlyingComptroller = address(CToken(underlying).comptroller());
69         comp = IComptroller(underlyingComptroller).getCompAddress();
70     }
71 
72     /**
73      * @notice Manually claim comp rewards by user
74      * @return The amount of comp rewards user claims
75      */
76     function claimComp(address account) public returns (uint256) {
77         harvestComp();
78 
79         updateSupplyIndex();
80         updateSupplierIndex(account);
81 
82         uint256 compBalance = compUserAccrued[account];
83         if (compBalance > 0) {
84             // Transfer user comp and subtract the balance in supplyState
85             EIP20Interface(comp).transfer(account, compBalance);
86             supplyState.balance = sub_(supplyState.balance, compBalance);
87 
88             // Clear user's comp accrued.
89             compUserAccrued[account] = 0;
90 
91             return compBalance;
92         }
93         return 0;
94     }
95 
96     /*** CToken Overrides ***/
97 
98     /**
99      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
100      * @param spender The address of the account performing the transfer
101      * @param src The address of the source account
102      * @param dst The address of the destination account
103      * @param tokens The number of tokens to transfer
104      * @return Whether or not the transfer succeeded
105      */
106     function transferTokens(
107         address spender,
108         address src,
109         address dst,
110         uint256 tokens
111     ) internal returns (uint256) {
112         harvestComp();
113 
114         updateSupplyIndex();
115         updateSupplierIndex(src);
116         updateSupplierIndex(dst);
117 
118         return super.transferTokens(spender, src, dst, tokens);
119     }
120 
121     /*** Safe Token ***/
122 
123     /**
124      * @notice Transfer the underlying to this contract
125      * @param from Address to transfer funds from
126      * @param amount Amount of underlying to transfer
127      * @param isNative The amount is in native or not
128      * @return The actual amount that is transferred
129      */
130     function doTransferIn(
131         address from,
132         uint256 amount,
133         bool isNative
134     ) internal returns (uint256) {
135         uint256 transferredIn = super.doTransferIn(from, amount, isNative);
136 
137         harvestComp();
138         updateSupplyIndex();
139         updateSupplierIndex(from);
140 
141         return transferredIn;
142     }
143 
144     /**
145      * @notice Transfer the underlying from this contract
146      * @param to Address to transfer funds to
147      * @param amount Amount of underlying to transfer
148      * @param isNative The amount is in native or not
149      */
150     function doTransferOut(
151         address payable to,
152         uint256 amount,
153         bool isNative
154     ) internal {
155         harvestComp();
156         updateSupplyIndex();
157         updateSupplierIndex(to);
158 
159         super.doTransferOut(to, amount, isNative);
160     }
161 
162     /*** Internal functions ***/
163 
164     function harvestComp() internal {
165         address[] memory holders = new address[](1);
166         holders[0] = address(this);
167         CToken[] memory cTokens = new CToken[](1);
168         cTokens[0] = CToken(underlying);
169 
170         // CCToken contract will never borrow assets from Compound.
171         IComptroller(underlyingComptroller).claimComp(holders, cTokens, false, true);
172     }
173 
174     function updateSupplyIndex() internal {
175         uint256 compAccrued = sub_(compBalance(), supplyState.balance);
176         uint256 supplyTokens = CToken(address(this)).totalSupply();
177         Double memory ratio = supplyTokens > 0 ? fraction(compAccrued, supplyTokens) : Double({mantissa: 0});
178         Double memory index = add_(Double({mantissa: supplyState.index}), ratio);
179 
180         // Update supplyState.
181         supplyState.index = index.mantissa;
182         supplyState.balance = compBalance();
183     }
184 
185     function updateSupplierIndex(address supplier) internal {
186         Double memory supplyIndex = Double({mantissa: supplyState.index});
187         Double memory supplierIndex = Double({mantissa: supplierState[supplier]});
188         Double memory deltaIndex = sub_(supplyIndex, supplierIndex);
189         if (deltaIndex.mantissa > 0) {
190             uint256 supplierTokens = CToken(address(this)).balanceOf(supplier);
191             uint256 supplierDelta = mul_(supplierTokens, deltaIndex);
192             compUserAccrued[supplier] = add_(compUserAccrued[supplier], supplierDelta);
193             supplierState[supplier] = supplyIndex.mantissa;
194         }
195     }
196 
197     function compBalance() internal view returns (uint256) {
198         return EIP20Interface(comp).balanceOf(address(this));
199     }
200 }
