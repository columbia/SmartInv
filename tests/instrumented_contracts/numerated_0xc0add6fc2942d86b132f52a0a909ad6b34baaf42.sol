1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.6;
3 
4 /** 
5  * METEORA
6  *
7  * Lunaris Incorporation - 2022
8  * https://meteora.lunaris.inc
9  *
10  * TGE contract of the METEORA MRA Token, following the
11  * ERC20 standard on Ethereum.
12  *
13  * Audited on 17/03/2022 - info: meteora(at)lunaris.inc
14  * 
15  * TOTAL FIXED SUPPLY: 100,000,000 MRA
16  * 
17 **/
18 
19 contract Meteora {
20     string private _name;
21     string private _symbol;
22     uint256 private _totalSupply;
23     address private Lunaris;
24     uint8 private _decimals;
25     
26     mapping (address => uint256) private _balances;
27     mapping (address => mapping(address => uint256)) private _allowances;
28     
29     constructor() {
30         _name = "Meteora";
31         _symbol = "MRA";
32         _decimals = 18;
33         _totalSupply = 100000000 * (10 ** 18);
34         
35         // Owner - Lunaris Incorporation
36         Lunaris = address(0xf0fA5BC481aDB0ed35c180B52aDCBBEad455e808);
37         
38         // All of the tokens are sent to the Lunaris Wallet
39         // then sent to external distribution contracts following
40         // the Tokenomics documents.
41         //
42         // Please check out https://meteora.lunaris.inc for more information.
43         _balances[Lunaris] = _totalSupply;
44     }
45     
46     /*******************/
47     /* ERC20 FUNCTIONS */
48     /*******************/
49     
50     function name() public view returns (string memory) {
51         return _name;
52     }
53     
54     function symbol() public view returns (string memory) {
55         return _symbol;
56     }
57     
58     function decimals() public view returns (uint8) {
59         return _decimals;
60     }
61     
62     function totalSupply() public view returns (uint256) {
63         return _totalSupply;
64     }
65     
66     function balanceOf(address account) public view returns (uint256) {
67         return _balances[account];
68     }
69     
70     function transfer(address recipient, uint256 amount) public returns (bool) {
71         _transfer(_msgSender(), recipient, amount);
72         return true;
73     }
74     
75     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
76         uint256 currentAllowance = _allowances[sender][_msgSender()];
77         
78         require(currentAllowance >= amount, "METEORA: You do not have enough allowance to perform this action!");
79         
80         _transfer(sender, recipient, amount);
81         
82         unchecked {
83             _approve(sender, _msgSender(), currentAllowance - amount);
84         }
85         
86         return true;
87     }
88     
89     function approve(address spender, uint256 amount) public returns (bool) {
90         _approve(_msgSender(), spender, amount);
91         return true;
92     }
93     
94     function allowance(address owner, address spender) public view returns (uint256) {
95         return _allowances[owner][spender];
96     }
97     
98     
99     /*************************/
100     /* ADDITIONNAL FUNCTIONS */
101     /*************************/
102     
103     /** 
104      * MRA is burnable. Any MRA owner can burn his tokens if need be.
105      * The total supply is updated accordingly.
106     **/
107     
108     function burn(uint256 amount) public returns (bool) {
109         _burn(_msgSender(), amount);
110         return true;
111     }
112 
113     
114     /**********************/
115     /* CONTRACT FUNCTIONS */
116     /**********************/
117     
118     function _transfer(address sender, address recipient, uint256 amount) private {
119         require(sender != address(0), "METEORA: The sender cannot be the Zero Address!");
120         require(recipient != address(0), "METEORA: The recipient cannot be the Zero Address!");
121         
122         uint256 senderBalance = _balances[sender];
123         
124         require(senderBalance >= amount, "METEORA: Sender does not have enough MRA for this operation!");
125         
126         unchecked {
127             _balances[sender] = senderBalance - amount;
128         }
129         
130         _balances[recipient] += amount;
131         
132         emit Transfer(sender, recipient, amount);
133     }
134     
135     function _approve(address owner, address spender, uint256 amount) private {
136         require(owner != address(0), "METEORA: The owner cannot be the Zero Address!");
137         require(spender != address(0), "METEORA: The spender cannot be the Zero Address!");
138         
139         _allowances[owner][spender] = amount;
140         emit Approval(owner, spender, amount);
141     }
142     
143     function _burn(address owner, uint256 amount) private {
144         uint256 accountBalance = _balances[owner];
145         
146         require(owner != address(0), "METEORA: Owner cannot be the Zero Address!");
147         require(accountBalance >= amount, "METEORA: You do not have enough tokens to burn!");
148         
149         unchecked {
150             _balances[owner] = accountBalance - amount;
151         }
152         
153         _totalSupply -= amount;
154         
155         emit Burned(owner, amount);
156     }
157     
158     /**********/
159     /* EVENTS */
160     /**********/
161     
162     event Transfer(address indexed sender, address indexed recipient, uint256 amount);
163     event Approval(address indexed owner, address indexed spender, uint256 amount);
164     event Burned(address indexed burner, uint256 amount);
165     
166     /***********/
167     /* CONTEXT */
168     /***********/
169     
170     function _msgSender() internal view virtual returns (address) {
171         return msg.sender;
172     }
173 }