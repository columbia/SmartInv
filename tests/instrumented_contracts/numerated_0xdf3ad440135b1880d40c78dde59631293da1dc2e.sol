1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint256);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 interface IERC20Metadata is IERC20 {
19     function name() external view returns (string memory);
20     function symbol() external view returns (string memory);
21     function decimals() external view returns (uint8);
22 }
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 abstract contract Functional {
35     function toString(uint256 value) internal pure returns (string memory) {
36         if (value == 0) {
37             return "0";
38         }
39         uint256 temp = value;
40         uint256 digits;
41         while (temp != 0) {
42             digits++;
43             temp /= 10;
44         }
45         bytes memory buffer = new bytes(digits);
46         while (value != 0) {
47             digits -= 1;
48             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
49             value /= 10;
50         }
51         return string(buffer);
52     }
53     
54     bool private _reentryKey = false;
55     modifier reentryLock {
56         require(!_reentryKey, "attempt reenter locked function");
57         _reentryKey = true;
58         _;
59         _reentryKey = false;
60     }
61 }
62 
63 contract GASfactory is Context, Functional, IERC20, IERC20Metadata {
64     mapping(address => uint256) private _balances;
65 
66     mapping(address => mapping(address => uint256)) private _allowances;
67 	mapping(address => uint256) private _timeStamp;
68 
69     uint256 private _totalSupply;
70 	uint256 private DAY = 60 * 60 * 24;
71     uint256 timer;
72 
73     string private _name;
74     string private _symbol;
75     
76 
77     constructor() {
78         _name = "GASfactory";
79         _symbol = "GAS";
80         timer = 1667149200;
81     }
82 
83     /**
84      * @dev deposits daily mining coins into your wallet
85      */    
86     function mint() external reentryLock {
87         require( block.timestamp > timer, "Minting will start soon");
88     	require( block.timestamp - _timeStamp[_msgSender()] > DAY, "Min 1 day between mining");
89     	_timeStamp[_msgSender()] = block.timestamp;
90     	_mint( _msgSender(), _calculateAmount() );
91     }
92     
93     /**
94      * @dev shares the unix timestamp of the next time user can mine coins
95      */
96     function nextClaimTimestamp( address miner ) external view returns(uint256) {
97     	return _timeStamp[miner] + DAY;
98     }
99     
100     /**
101      * @dev calculates the current coin amount to be dispersed per txn
102      *      (reduces daily)
103      */
104     function _calculateAmount() public view returns (uint256) {
105     	// timer is set when contract is deployed on the blockchain and is the basis for all
106     	// calculations.
107     	
108     	// first we determine the amount of time the contract has been running in days
109     	uint256 dt = (block.timestamp - timer) / DAY;
110     	
111     	// calculate the bonus based on dt (early adopters can mint more coins)
112     	// bonus will stop 2 years after deployment.
113     	return (10 ** 18) * (73000 / (dt + 1));
114     }
115 
116     function name() public view virtual override returns (string memory) {
117         return _name;
118     }
119 
120     function symbol() public view virtual override returns (string memory) {
121         return _symbol;
122     }
123 
124     function decimals() public view virtual override returns (uint8) {
125         return 18;
126     }
127 
128     function totalSupply() public view virtual override returns (uint256) {
129         return _totalSupply;
130     }
131 
132     function balanceOf(address account) public view virtual override returns (uint256) {
133         return _balances[account];
134     }
135 
136     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
137         _transfer(_msgSender(), recipient, amount);
138         return true;
139     }
140 
141     function allowance(address owner, address spender) public view virtual override returns (uint256) {
142         return _allowances[owner][spender];
143     }
144 
145     function approve(address spender, uint256 amount) public virtual override returns (bool) {
146         _approve(_msgSender(), spender, amount);
147         return true;
148     }
149 
150     function transferFrom(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) public virtual override returns (bool) {
155         _transfer(sender, recipient, amount);
156 
157         uint256 currentAllowance = _allowances[sender][_msgSender()];
158         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
159         unchecked {
160             _approve(sender, _msgSender(), currentAllowance - amount);
161         }
162 
163         return true;
164     }
165 
166     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
167         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
168         return true;
169     }
170 
171     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
172         uint256 currentAllowance = _allowances[_msgSender()][spender];
173         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
174         unchecked {
175             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
176         }
177 
178         return true;
179     }
180 
181     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
182         require(sender != address(0), "ERC20: transfer from the zero address");
183         require(recipient != address(0), "ERC20: transfer to the zero address");
184 
185         uint256 senderBalance = _balances[sender];
186         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
187         unchecked {
188             _balances[sender] = senderBalance - amount;
189         }
190         _balances[recipient] += amount;
191 
192         emit Transfer(sender, recipient, amount);
193     }
194 
195     function _mint(address account, uint256 amount) internal virtual {
196         require(account != address(0), "ERC20: mint to the zero address");
197 
198         _totalSupply += amount;
199         _balances[account] += amount;
200         emit Transfer(address(0), account, amount);
201     }
202 
203     function _burn(address account, uint256 amount) internal virtual {
204         require(account != address(0), "ERC20: burn from the zero address");
205 
206         uint256 accountBalance = _balances[account];
207         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
208         unchecked {
209             _balances[account] = accountBalance - amount;
210         }
211         _totalSupply -= amount;
212 
213         emit Transfer(account, address(0), amount);
214     }
215 
216     function _approve(
217         address owner,
218         address spender,
219         uint256 amount
220     ) internal virtual {
221         require(owner != address(0), "ERC20: approve from 0x0");
222         require(spender != address(0), "ERC20: approve to 0x0");
223 
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     receive() external payable {}
229     
230     fallback() external payable {}
231 }