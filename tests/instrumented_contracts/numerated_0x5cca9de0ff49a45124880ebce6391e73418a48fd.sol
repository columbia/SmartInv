1 pragma solidity ^0.4.18;
2 
3 /// @title DepositWalletInterface
4 ///
5 /// Defines an interface for a wallet that can be deposited/withdrawn by 3rd contract
6 contract DepositWalletInterface {
7     function deposit(address _asset, address _from, uint256 amount) public returns (uint);
8     function withdraw(address _asset, address _to, uint256 amount) public returns (uint);
9 }
10 
11 /**
12  * @title Owned contract with safe ownership pass.
13  *
14  * Note: all the non constant functions return false instead of throwing in case if state change
15  * didn't happen yet.
16  */
17 contract Owned {
18     /**
19      * Contract owner address
20      */
21     address public contractOwner;
22 
23     /**
24      * Contract owner address
25      */
26     address public pendingContractOwner;
27 
28     function Owned() {
29         contractOwner = msg.sender;
30     }
31 
32     /**
33     * @dev Owner check modifier
34     */
35     modifier onlyContractOwner() {
36         if (contractOwner == msg.sender) {
37             _;
38         }
39     }
40 
41     /**
42      * @dev Destroy contract and scrub a data
43      * @notice Only owner can call it
44      */
45     function destroy() onlyContractOwner {
46         suicide(msg.sender);
47     }
48 
49     /**
50      * Prepares ownership pass.
51      *
52      * Can only be called by current owner.
53      *
54      * @param _to address of the next owner. 0x0 is not allowed.
55      *
56      * @return success.
57      */
58     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
59         if (_to  == 0x0) {
60             return false;
61         }
62 
63         pendingContractOwner = _to;
64         return true;
65     }
66 
67     /**
68      * Finalize ownership pass.
69      *
70      * Can only be called by pending owner.
71      *
72      * @return success.
73      */
74     function claimContractOwnership() returns(bool) {
75         if (pendingContractOwner != msg.sender) {
76             return false;
77         }
78 
79         contractOwner = pendingContractOwner;
80         delete pendingContractOwner;
81 
82         return true;
83     }
84 }
85 
86 contract ERC20Interface {
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(address indexed from, address indexed spender, uint256 value);
89     string public symbol;
90 
91     function totalSupply() constant returns (uint256 supply);
92     function balanceOf(address _owner) constant returns (uint256 balance);
93     function transfer(address _to, uint256 _value) returns (bool success);
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
95     function approve(address _spender, uint256 _value) returns (bool success);
96     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
97 }
98 
99 /**
100  * @title Generic owned destroyable contract
101  */
102 contract Object is Owned {
103     /**
104     *  Common result code. Means everything is fine.
105     */
106     uint constant OK = 1;
107     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
108 
109     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
110         for(uint i=0;i<tokens.length;i++) {
111             address token = tokens[i];
112             uint balance = ERC20Interface(token).balanceOf(this);
113             if(balance != 0)
114                 ERC20Interface(token).transfer(_to,balance);
115         }
116         return OK;
117     }
118 
119     function checkOnlyContractOwner() internal constant returns(uint) {
120         if (contractOwner == msg.sender) {
121             return OK;
122         }
123 
124         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
125     }
126 }
127 
128 contract BaseWallet is Object, DepositWalletInterface {
129 
130     uint constant CUSTOMER_WALLET_SCOPE = 60000;
131     uint constant CUSTOMER_WALLET_NOT_OK = CUSTOMER_WALLET_SCOPE + 1;
132 
133     address public customer;
134 
135     modifier onlyCustomer() {
136         if (msg.sender != customer) {
137             revert();
138         }
139         _;
140     }
141 
142     function() public payable {
143         revert();
144     }
145 
146     /// Init contract by setting Emission ProviderWallet address
147     /// that can be associated and have an account for this contract
148     ///
149     /// @dev Allowed only for contract owner
150     ///
151     /// @param _customer Emission Provider address
152     ///
153     /// @return  code
154     function init(address _customer) public onlyContractOwner returns (uint code) {
155         require(_customer != 0x0);
156         customer = _customer;
157         return OK;
158     }
159 
160     /// Call `selfdestruct` when contract is not needed anymore. Also takes a list of tokens
161     /// that can be associated and have an account for this contract
162     ///
163     /// @dev Allowed only for contract owner
164     ///
165     /// @param tokens an array of tokens addresses
166     function destroy(address[] tokens) public onlyContractOwner {
167         withdrawnTokens(tokens, msg.sender);
168         selfdestruct(msg.sender);
169     }
170 
171     /// @dev Call destroy(address[] tokens) instead
172     function destroy() public onlyContractOwner {
173         revert();
174     }
175 
176     /// Deposits some amount of tokens on wallet's account using ERC20 tokens
177     ///
178     /// @dev Allowed only for rewards
179     ///
180     /// @param _asset an address of token
181     /// @param _from an address of a sender who is willing to transfer her resources
182     /// @param _amount an amount of tokens (resources) a sender wants to transfer
183     ///
184     /// @return code
185     function deposit(address _asset, address _from, uint256 _amount) public onlyCustomer returns (uint) {
186         if (!ERC20Interface(_asset).transferFrom(_from, this, _amount)) {
187             return CUSTOMER_WALLET_NOT_OK;
188         }
189         return OK;
190     }
191 
192     /// Withdraws some amount of tokens from wallet's account using ERC20 tokens
193     ///
194     /// @dev Allowed only for rewards
195     ///
196     /// @param _asset an address of token
197     /// @param _to an address of a receiver who is willing to get stored resources
198     /// @param _amount an amount of tokens (resources) a receiver wants to get
199     ///
200     /// @return  code
201     function withdraw(address _asset, address _to, uint256 _amount) public onlyCustomer returns (uint) {
202         if (!ERC20Interface(_asset).transfer(_to, _amount)) {
203             return CUSTOMER_WALLET_NOT_OK;
204         }
205         return OK;
206     }
207 
208     /// Approve some amount of tokens from wallet's account using ERC20 tokens
209     ///
210     /// @dev Allowed only for rewards
211     ///
212     /// @param _asset an address of token
213     /// @param _to an address of a receiver who is willing to get stored resources
214     /// @param _amount an amount of tokens (resources) a receiver wants to get
215     ///
216     /// @return  code
217     function approve(address _asset, address _to, uint256 _amount) public onlyCustomer returns (uint) {
218         if (!ERC20Interface(_asset).approve(_to, _amount)) {
219             return CUSTOMER_WALLET_NOT_OK;
220         }
221         return OK;
222     }
223 }
224 
225 contract ProfiteroleWallet is BaseWallet {
226 	
227 }