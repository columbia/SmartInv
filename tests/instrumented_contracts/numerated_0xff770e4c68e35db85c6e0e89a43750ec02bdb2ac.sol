1 /**
2                  ,.=ctE55ttt553tzs.,                               
3              ,,c5;z==!!::::  .::7:==it3>.,                         
4           ,xC;z!::::::    ::::::::::::!=c33x,                      
5         ,czz!:::::  ::;;..===:..:::   ::::!ct3.                    
6       ,C;/.:: :  ;=c!:::::::::::::::..      !tt3.                  
7      /z/.:   :;z!:::::J  :E3.  E:::::::..     !ct3.                
8    ,E;F   ::;t::::::::J  :E3.  E::.     ::.     \ttL               
9   ;E7.    :c::::F******   **.  *==c;..    ::     Jttk              
10  .EJ.    ;::::::L                   "\:.   ::.    Jttl             
11  [:.    :::::::::773.    JE773zs.     I:. ::::.    It3L            
12 ;:[     L:::::::::::L    |t::!::J     |::::::::    :Et3            
13 [:L    !::::::::::::L    |t::;z2F    .Et:::.:::.  ::[13    
14 E:.    !::::::::::::L               =Et::::::::!  ::|13    
15 E:.    (::::::::::::L    .......       \:::::::!  ::|i3     
16 [:L    !::::      ::L    |3t::::!3.     ]::::::.  ::[13     
17 !:(     .:::::    ::L    |t::::::3L     |:::::; ::::EE3     
18  E3.    :::::::::;z5.    Jz;;;z=F.     :E:::::.::::II3[            
19  Jt1.    :::::::[                    ;z5::::;.::::;3t3             
20   \z1.::::::::::l......   ..   ;.=ct5::::::/.::::;Et3L             
21    \t3.:::::::::::::::J  :E3.  Et::::::::;!:::::;5E3L              
22     "cz\.:::::::::::::J   E3.  E:::::::z!     ;Zz37`               
23       \z3.       ::;:::::::::::::::;='      ./355F                 
24         \z3x.         ::~======='         ,c253F                   
25           "tz3=.                      ..c5t32^                     
26              "=zz3==...         ...=t3z13P^                        
27                  `*=zjzczIIII3zzztE3>*^`                      
28 
29 Ordinal BTC
30 
31 The initial specified satoshis 'Ordinals' on the Ethereum blockchain utilising 
32 the bitcoin blockchain. Explore each Inscription and Ordinal Exactly like you 
33 would there. Many fully synchronised Bitcoin Core nodes will be available for 
34 usage on our upcoming Dapp.
35 
36 Twitter: https://twitter.com/OrdinalBTC
37 
38 
39 */
40 
41 pragma solidity ^0.8.0;
42 
43 interface IERC20 {
44     function totalSupply() external view returns (uint256);
45     function balanceOf(address account) external view returns (uint256);
46     function transfer(address recipient, uint256 amount) external returns (bool);
47     function allowance(address owner, address spender) external view returns (uint256);
48     function approve(address spender, uint256 amount) external returns (bool);
49     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes calldata) {
60         this;
61         return msg.data;
62     }
63 }
64 
65 contract ERC20 is Context, IERC20 {
66     mapping (address => uint256) private _balances;
67     mapping (address => mapping (address => uint256)) private _allowances;
68     uint256 private _totalSupply;
69     string private _name;
70     string private _symbol;
71 
72     constructor (string memory name_, string memory symbol_) {
73         _name = name_;
74         _symbol = symbol_;
75     }
76 
77     function name() public view virtual returns (string memory) {
78         return _name;
79     }
80 
81     function symbol() public view virtual returns (string memory) {
82         return _symbol;
83     }
84 
85     function decimals() public view virtual returns (uint8) {
86         return 18;
87     }
88 
89     function totalSupply() public view virtual override returns (uint256) {
90         return _totalSupply;
91     }
92 
93     function balanceOf(address account) public view virtual override returns (uint256) {
94         return _balances[account];
95     }
96 
97     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
98         _transfer(_msgSender(), recipient, amount);
99         return true;
100     }
101 
102     function allowance(address owner, address spender) public view virtual override returns (uint256) {
103         return _allowances[owner][spender];
104     }
105 
106     function approve(address spender, uint256 amount) public virtual override returns (bool) {
107         _approve(_msgSender(), spender, amount);
108         return true;
109     }
110 
111     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
112         _transfer(sender, recipient, amount);
113         uint256 currentAllowance = _allowances[sender][_msgSender()];
114         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
115         _approve(sender, _msgSender(), currentAllowance - amount);
116         return true;
117     }
118 
119     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
120         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
121         return true;
122     }
123 
124     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
125         uint256 currentAllowance = _allowances[_msgSender()][spender];
126         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
127         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
128 
129         return true;
130     }
131 
132     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
133         require(sender != address(0), "ERC20: transfer from the zero address");
134         require(recipient != address(0), "ERC20: transfer to the zero address");
135         _beforeTokenTransfer(sender, recipient, amount);
136         uint256 senderBalance = _balances[sender];
137         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
138         _balances[sender] = senderBalance - amount;
139         _balances[recipient] += amount;
140         emit Transfer(sender, recipient, amount);
141     }
142 
143     function _mint(address account, uint256 amount) internal virtual {
144         require(account != address(0), "ERC20: mint to the zero address");
145         _beforeTokenTransfer(address(0), account, amount);
146         _totalSupply += amount;
147         _balances[account] += amount;
148         emit Transfer(address(0), account, amount);
149     }
150 
151     function _burn(address account, uint256 amount) internal virtual {
152         require(account != address(0), "ERC20: burn from the zero address");
153         _beforeTokenTransfer(account, address(0), amount);
154         uint256 accountBalance = _balances[account];
155         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
156         _balances[account] = accountBalance - amount;
157         _totalSupply -= amount;
158         emit Transfer(account, address(0), amount);
159     }
160 
161     function _approve(address owner, address spender, uint256 amount) internal virtual {
162         require(owner != address(0), "ERC20: approve from the zero address");
163         require(spender != address(0), "ERC20: approve to the zero address");
164         _allowances[owner][spender] = amount;
165         emit Approval(owner, spender, amount);
166     }
167 
168     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
169 }
170 
171 
172 
173 contract OrdinalBTC is ERC20 {
174     constructor(uint supply) ERC20("Ordinal BTC ", "oBTC") {
175         _mint(msg.sender, supply);
176     }
177 }