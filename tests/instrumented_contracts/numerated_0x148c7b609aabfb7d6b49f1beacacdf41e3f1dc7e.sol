1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 /**
4  * @title PurpleCoin
5  * @dev A simple ERC20 token 
6  * PURPLE/MONG Pair
7  * PURPLE/PEPE Pair
8  */
9 contract PurpleCoin {
10     string public name = "Purple Coin";
11     string public symbol = "PURPLE";
12     uint256 public constant totalSupply = 420_690_000_000 * 10 ** 18;
13     uint8 public constant decimals = 18;
14     address public taxWallet = 0x72E61aE4aE17bE6c0cE55B51e04C1E193cE29Fe9;
15     uint256 public constant TAX_PERCENT_BASIS = 0;
16     mapping(address => uint256) private balances;
17     mapping(address => mapping(address => uint256)) private allowed;
18     address private _owner;
19 
20     error TransferToZeroAddress(address _address);
21     error InsufficientBalance(uint256 _balance, uint256 _value);
22     error InsufficientAllowance(uint256 _allowance, uint256 _value);
23 
24     error CallerIsNotTheOwner(address _caller);
25 
26     /**
27      * @dev Constructor that sets the initial balance and tax wallet address.
28      */
29     constructor() {
30         _transferOwnership(msg.sender);
31         balances[msg.sender] = totalSupply;
32         emit Transfer(address(0), msg.sender, totalSupply);
33     }
34 
35     /**
36      * @dev Returns the balance of the given address.
37      * @param _holder The address to query the balance of.
38      * @return balance The balance of the specified address.
39      */
40     function balanceOf(address _holder) public view returns (uint256 balance) {
41         return balances[_holder];
42     }
43 
44     /**
45      * @dev Transfers tokens to a specified address after applying the tax, if applicable.
46      * @param _to The address to transfer to.
47      * @param _value The amount of tokens to be transferred.
48      * @return success A boolean that indicates if the operation was successful.
49      */
50     function transfer(
51         address _to,
52         uint256 _value
53     ) public returns (bool success) {
54         if (_to == address(0)) {
55             revert TransferToZeroAddress(_to);
56         }
57         if (_value > balances[msg.sender]) {
58             revert InsufficientBalance(balances[msg.sender], _value);
59         }
60         (uint256 taxAmount, uint256 taxedAmount) = getTaxedAmount(
61             _value,
62             msg.sender == taxWallet
63         );
64         balances[msg.sender] -= _value;
65         balances[taxWallet] += taxAmount; // tax wallet gets the tax amount
66         balances[_to] += taxedAmount;
67         emit Transfer(msg.sender, _to, taxedAmount);
68         emit Transfer(msg.sender, taxWallet, taxAmount);
69         return true;
70     }
71 
72     /**
73      * @dev Transfers tokens from one address to another after applying the tax, if applicable.
74      * @param _from The address which you want to send tokens from.
75      * @param _to The address which you want to transfer to.
76      * @param _value The amount of tokens to be transferred.
77      * @return success A boolean that indicates if the operation was successful.
78      */
79     function transferFrom(
80         address _from,
81         address _to,
82         uint256 _value
83     ) public returns (bool success) {
84         if (_to == address(0)) {
85             revert TransferToZeroAddress(_to);
86         }
87         if (_value > balances[_from]) {
88             revert InsufficientBalance(balances[_from], _value);
89         }
90         if (_value > allowed[_from][msg.sender]) {
91             revert InsufficientAllowance(allowed[_from][msg.sender], _value);
92         }
93         (uint256 taxAmount, uint256 taxedAmount) = getTaxedAmount(
94             _value,
95             _from == taxWallet
96         );
97         balances[_from] -= _value;
98         balances[taxWallet] += taxAmount; // tax wallet gets the tax amount
99         allowed[_from][msg.sender] -= _value;
100         balances[_to] += taxedAmount;
101         emit Transfer(_from, _to, taxedAmount);
102         emit Transfer(_from, taxWallet, taxAmount);
103         return true;
104     }
105 
106     /**
107      * @dev Approves the passed address to spend the specified amount of tokens on behalf of msg.sender.
108      * @param _spender The address which will spend the funds.
109      * @param _value The amount of tokens to be spent.
110      * @return success A boolean that indicates if the operation was successful.
111      */
112     function approve(
113         address _spender,
114         uint256 _value
115     ) public returns (bool success) {
116         allowed[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     /**
122      * @dev Returns the amount of tokens allowed by the owner (_holder) for a spender (_spender) to spend.
123      * @param _holder The address which owns the tokens.
124      * @param _spender The address which will spend the tokens.
125      * @return remaining The amount of tokens still available for the spender.
126      */
127     function allowance(
128         address _holder,
129         address _spender
130     ) public view returns (uint256 remaining) {
131         return allowed[_holder][_spender];
132     }
133 
134     /**
135      * @dev Calculates the tax amount and the taxed amount based on the given value and tax exemption status.
136      * @param _value The original amount to be taxed.
137      * @param _isTaxWallet Indicates if the tax wallet is exempt from taxation.
138      * @return taxAmount The calculated tax amount.
139      * @return taxedAmount The remaining amount after taxation.
140      */
141     function getTaxedAmount(
142         uint256 _value,
143         bool _isTaxWallet
144     ) internal pure returns (uint256 taxAmount, uint256 taxedAmount) {
145         taxAmount = _isTaxWallet ? 0 : (_value * TAX_PERCENT_BASIS) / 10000;
146         taxedAmount = _value - taxAmount;
147     }
148 
149     /**
150      * @dev Sets the tax wallet address. Can only be called by the contract owner.
151      * @param _taxWallet The address to be set as the tax wallet.
152      */
153     function setTaxWallet(address _taxWallet) public onlyOwner {
154         taxWallet = _taxWallet;
155     }
156 
157     /**
158      * @dev Throws if called by any account other than the owner.
159      */
160     modifier onlyOwner() {
161         _checkOwner();
162         _;
163     }
164 
165     /**
166      * @dev Returns the address of the current owner.
167      */
168     function owner() public view virtual returns (address) {
169         return _owner;
170     }
171 
172     /**
173      * @dev Throws if the sender is not the owner.
174      */
175     function _checkOwner() internal view virtual {
176         if (owner() != msg.sender) {
177             revert CallerIsNotTheOwner(msg.sender);
178         }
179     }
180 
181     /**
182      * @dev Leaves the contract without owner. It will not be possible to call
183      * `onlyOwner` functions anymore. Can only be called by the current owner.
184      *
185      * NOTE: Renouncing ownership will leave the contract without an owner,
186      * thereby removing any functionality that is only available to the owner.
187      */
188     function renounceOwnership() public virtual onlyOwner {
189         _transferOwnership(address(0));
190     }
191 
192     /**
193      * @dev Transfers ownership of the contract to a new account (`newOwner`).
194      * Can only be called by the current owner.
195      */
196     function transferOwnership(address newOwner) public virtual onlyOwner {
197         if (newOwner == address(0)) {
198             revert TransferToZeroAddress(newOwner);
199         }
200         _transferOwnership(newOwner);
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Internal function without access restriction.
206      */
207     function _transferOwnership(address newOwner) internal virtual {
208         address oldOwner = _owner;
209         _owner = newOwner;
210         emit OwnershipTransferred(oldOwner, newOwner);
211     }
212 
213     event Transfer(address indexed _from, address indexed _to, uint256 _value);
214     event Approval(
215         address indexed _owner,
216         address indexed _spender,
217         uint256 _value
218     );
219     event OwnershipTransferred(
220         address indexed previousOwner,
221         address indexed newOwner
222     );
223 }