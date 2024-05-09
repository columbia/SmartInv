1 //   __    __ _         _                   _____      _
2 //  / / /\ \ (_)___  __| | ___  _ __ ___   /__   \___ | | _____ _ __
3 //  \ \/  \/ / / __|/ _` |/ _ \| '_ ` _ \    / /\/ _ \| |/ / _ \ '_ \
4 //   \  /\  /| \__ \ (_| | (_) | | | | | |  / / | (_) |   <  __/ | | |
5 //    \/  \/ |_|___/\__,_|\___/|_| |_| |_|  \/   \___/|_|\_\___|_| |_|
6 //
7 //  Author: Grzegorz Kucmierz
8 //  Source: https://github.com/gkucmierz/wisdom-token
9 //    Docs: https://gkucmierz.github.io/wisdom-token
10 //
11 
12 pragma solidity ^0.7.2;
13 
14 contract ERC20 {
15     string public name;
16     string public symbol;
17     uint8 public decimals;
18     uint256 public totalSupply;
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) private allowed;
21     function _transfer(address sender, address recipient, uint256 amount) internal virtual returns (bool) {
22         require(balanceOf[sender] >= amount);
23         balanceOf[sender] -= amount;
24         balanceOf[recipient] += amount;
25         emit Transfer(sender, recipient, amount);
26         return true;
27     }
28     function transfer(address recipient, uint256 amount) public returns (bool) {
29         return _transfer(msg.sender, recipient, amount);
30     }
31     function allowance(address holder, address spender) public view returns (uint256) {
32         return allowed[holder][spender];
33     }
34     function approve(address spender, uint256 amount) public returns (bool) {
35         require(balanceOf[msg.sender] >= amount);
36         allowed[msg.sender][spender] = amount;
37         emit Approval(msg.sender, spender, amount);
38         return true;
39     }
40     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
41         require(allowed[sender][msg.sender] >= amount);
42         _transfer(sender, recipient, amount);
43         allowed[sender][msg.sender] -= amount;
44         return true;
45     }
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed holder, address indexed spender, uint256 value);
49 }
50 
51 contract Ownable {
52     address owner;
53     address newOwner;
54 
55     constructor() {
56         owner = msg.sender;
57     }
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62     function changeOwner(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwner() public {
66         require(newOwner == msg.sender);
67         owner = msg.sender;
68         emit TransferOwnership(msg.sender);
69     }
70 
71     event TransferOwnership(address newOwner);
72 }
73 
74 interface IERC667Receiver {
75     function onTokenTransfer(address from, uint256 amount, bytes calldata data) external;
76 }
77 
78 contract ERC667 is ERC20 {
79     function transferAndCall(address recipient, uint amount, bytes calldata data) public returns (bool) {
80         bool success = _transfer(msg.sender, recipient, amount);
81         if (success){
82             IERC667Receiver(recipient).onTokenTransfer(msg.sender, amount, data);
83         }
84         return success;
85     }
86 }
87 
88 contract Pausable is Ownable {
89     bool public paused = true;
90     modifier whenNotPaused() {
91         require(!paused);
92         _;
93     }
94     modifier whenPaused() {
95         require(paused);
96         _;
97     }
98     function pause() onlyOwner whenNotPaused public {
99         paused = true;
100         emit Pause();
101     }
102     function unpause() onlyOwner whenPaused public {
103         paused = false;
104         emit Unpause();
105     }
106 
107     event Pause();
108     event Unpause();
109 }
110 
111 contract Issuable is ERC20, Ownable {
112     bool locked = false;
113     modifier whenUnlocked() {
114         require(!locked);
115         _;
116     }
117     function issue(address[] memory addr, uint256[] memory amount) public onlyOwner whenUnlocked {
118         require(addr.length == amount.length);
119         uint8 i;
120         uint256 sum = 0;
121         for (i = 0; i < addr.length; ++i) {
122             balanceOf[addr[i]] = amount[i];
123             emit Transfer(address(0x0), addr[i], amount[i]);
124             sum += amount[i];
125         }
126         totalSupply += sum;
127     }
128     function lock() internal onlyOwner whenUnlocked {
129         locked = true;
130     }
131 }
132 
133 contract WisdomToken is ERC667, Pausable, Issuable {
134     constructor() {
135         name = 'Experty Wisdom Token';
136         symbol = 'WIS';
137         decimals = 18;
138         totalSupply = 0;
139     }
140     function _transfer(address sender, address recipient, uint256 amount)
141         internal whenNotPaused override returns (bool) {
142         return super._transfer(sender, recipient, amount);
143     }
144     function alive(address _newOwner) public {
145         lock();
146         unpause();
147         changeOwner(_newOwner);
148     }
149 }