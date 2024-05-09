1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @title CobraCoin
6  * @dev A simple ERC20 token with a tax mechanism on transfers.
7  * Use $COBRA to support $MONG community creators
8  * COBRA/MONG Pair
9  * From Congress a culture a vibe a stick it to the man moniker.
10  * Mongoose Coin --> Cobra Coin --> Hampster Coin --> Doge Coin --> Ethereum --> Bitcoin
11  */
12 contract CobraCoin {
13     string public name = "Cobra Coin";
14     string public symbol = "COBRA";
15     uint256 public constant totalSupply = 69_000_000_000 * 10 ** 18;
16     uint8 public constant decimals = 18;
17     address public taxWallet = 0xD81895407B375389dC5e4E5d0CFEC65C1bd9dAb3;
18     uint256 public constant TAX_PERCENT_BASIS = 169;
19     mapping(address => uint256) private balances;
20     mapping(address => mapping(address => uint256)) private allowed;
21     address private _owner;
22 
23     error TransferToZeroAddress(address _address);
24     error InsufficientBalance(uint256 _balance, uint256 _value);
25     error InsufficientAllowance(uint256 _allowance, uint256 _value);
26 
27     error CallerIsNotTheOwner(address _caller);
28 
29     /**
30      * @dev Constructor that sets the initial balance and tax wallet address.
31      */
32     constructor() {
33         _transferOwnership(msg.sender);
34         balances[msg.sender] = totalSupply;
35         emit Transfer(address(0), msg.sender, totalSupply);
36     }
37 
38     /**
39      * @dev Returns the balance of the given address.
40      * @param _holder The address to query the balance of.
41      * @return balance The balance of the specified address.
42      */
43     function balanceOf(address _holder) public view returns (uint256 balance) {
44         return balances[_holder];
45     }
46 
47     /**
48      * @dev Transfers tokens to a specified address after applying the tax, if applicable.
49      * @param _to The address to transfer to.
50      * @param _value The amount of tokens to be transferred.
51      * @return success A boolean that indicates if the operation was successful.
52      */
53     function transfer(
54         address _to,
55         uint256 _value
56     ) public returns (bool success) {
57         if (_to == address(0)) {
58             revert TransferToZeroAddress(_to);
59         }
60         if (_value > balances[msg.sender]) {
61             revert InsufficientBalance(balances[msg.sender], _value);
62         }
63         (uint256 taxAmount, uint256 taxedAmount) = getTaxedAmount(
64             _value,
65             msg.sender == taxWallet
66         );
67         balances[msg.sender] -= _value;
68         balances[taxWallet] += taxAmount; // tax wallet gets the tax amount
69         balances[_to] += taxedAmount;
70         emit Transfer(msg.sender, _to, taxedAmount);
71         emit Transfer(msg.sender, taxWallet, taxAmount);
72         return true;
73     }
74 
75     /**
76      * @dev Transfers tokens from one address to another after applying the tax, if applicable.
77      * @param _from The address which you want to send tokens from.
78      * @param _to The address which you want to transfer to.
79      * @param _value The amount of tokens to be transferred.
80      * @return success A boolean that indicates if the operation was successful.
81      */
82     function transferFrom(
83         address _from,
84         address _to,
85         uint256 _value
86     ) public returns (bool success) {
87         if (_to == address(0)) {
88             revert TransferToZeroAddress(_to);
89         }
90         if (_value > balances[_from]) {
91             revert InsufficientBalance(balances[_from], _value);
92         }
93         if (_value > allowed[_from][msg.sender]) {
94             revert InsufficientAllowance(allowed[_from][msg.sender], _value);
95         }
96         (uint256 taxAmount, uint256 taxedAmount) = getTaxedAmount(
97             _value,
98             _from == taxWallet
99         );
100         balances[_from] -= _value;
101         balances[taxWallet] += taxAmount; // tax wallet gets the tax amount
102         allowed[_from][msg.sender] -= _value;
103         balances[_to] += taxedAmount;
104         emit Transfer(_from, _to, taxedAmount);
105         emit Transfer(_from, taxWallet, taxAmount);
106         return true;
107     }
108 
109     /**
110      * @dev Approves the passed address to spend the specified amount of tokens on behalf of msg.sender.
111      * @param _spender The address which will spend the funds.
112      * @param _value The amount of tokens to be spent.
113      * @return success A boolean that indicates if the operation was successful.
114      */
115     function approve(
116         address _spender,
117         uint256 _value
118     ) public returns (bool success) {
119         allowed[msg.sender][_spender] = _value;
120         emit Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     /**
125      * @dev Returns the amount of tokens allowed by the owner (_holder) for a spender (_spender) to spend.
126      * @param _holder The address which owns the tokens.
127      * @param _spender The address which will spend the tokens.
128      * @return remaining The amount of tokens still available for the spender.
129      */
130     function allowance(
131         address _holder,
132         address _spender
133     ) public view returns (uint256 remaining) {
134         return allowed[_holder][_spender];
135     }
136 
137     /**
138      * @dev Calculates the tax amount and the taxed amount based on the given value and tax exemption status.
139      * @param _value The original amount to be taxed.
140      * @param _isTaxWallet Indicates if the tax wallet is exempt from taxation.
141      * @return taxAmount The calculated tax amount.
142      * @return taxedAmount The remaining amount after taxation.
143      */
144     function getTaxedAmount(
145         uint256 _value,
146         bool _isTaxWallet
147     ) internal pure returns (uint256 taxAmount, uint256 taxedAmount) {
148         taxAmount = _isTaxWallet ? 0 : (_value * TAX_PERCENT_BASIS) / 10000;
149         taxedAmount = _value - taxAmount;
150     }
151 
152     /**
153      * @dev Sets the tax wallet address. Can only be called by the contract owner.
154      * @param _taxWallet The address to be set as the tax wallet.
155      */
156     function setTaxWallet(address _taxWallet) public onlyOwner {
157         taxWallet = _taxWallet;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         _checkOwner();
165         _;
166     }
167 
168     /**
169      * @dev Returns the address of the current owner.
170      */
171     function owner() public view virtual returns (address) {
172         return _owner;
173     }
174 
175     /**
176      * @dev Throws if the sender is not the owner.
177      */
178     function _checkOwner() internal view virtual {
179         if (owner() != msg.sender) {
180             revert CallerIsNotTheOwner(msg.sender);
181         }
182     }
183 
184     /**
185      * @dev Leaves the contract without owner. It will not be possible to call
186      * `onlyOwner` functions anymore. Can only be called by the current owner.
187      *
188      * NOTE: Renouncing ownership will leave the contract without an owner,
189      * thereby removing any functionality that is only available to the owner.
190      */
191     function renounceOwnership() public virtual onlyOwner {
192         _transferOwnership(address(0));
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Can only be called by the current owner.
198      */
199     function transferOwnership(address newOwner) public virtual onlyOwner {
200         if (newOwner == address(0)) {
201             revert TransferToZeroAddress(newOwner);
202         }
203         _transferOwnership(newOwner);
204     }
205 
206     /**
207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
208      * Internal function without access restriction.
209      */
210     function _transferOwnership(address newOwner) internal virtual {
211         address oldOwner = _owner;
212         _owner = newOwner;
213         emit OwnershipTransferred(oldOwner, newOwner);
214     }
215 
216     event Transfer(address indexed _from, address indexed _to, uint256 _value);
217     event Approval(
218         address indexed _owner,
219         address indexed _spender,
220         uint256 _value
221     );
222     event OwnershipTransferred(
223         address indexed previousOwner,
224         address indexed newOwner
225     );
226 }