1 pragma solidity ^0.4.20;
2 
3 /**
4  * split income between shareholders
5  */
6 contract Share {
7   address public owner;
8   address[] public shares;
9   bool public pause;
10   mapping (address => uint256) public holds;
11 
12   function Share() public {
13     owner = msg.sender;
14     shares.push(owner);
15     pause = false;
16   }
17 
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23   modifier whenNotPaused() {
24     require(!pause);
25     _;
26   }
27 
28   function pause() public onlyOwner {
29     pause = true;
30   }
31 
32   function unpause() public onlyOwner {
33     pause = false;
34   }
35 
36   function addShare(address _share) public onlyOwner {
37     for (uint i = 0; i < shares.length; i ++) {
38       if (shares[i] == _share) {
39         return;
40       }
41     }
42     shares.push(_share);
43   }
44 
45   function removeShare(address _share) public onlyOwner {
46     uint i = 0;
47     for (; i < shares.length; i ++) {
48       if (shares[i] == _share) {
49         break;
50       }
51     }
52 
53     if (i > shares.length - 1) {
54       //not found
55       return;
56     } else {
57       shares[i] = shares[shares.length - 1];
58       shares.length = shares.length - 1;
59       return;
60     }
61   }
62 
63   function split(uint256 value) internal {
64     uint256 each = value / shares.length;
65 
66     for (uint i = 0; i < shares.length; i ++) {
67       holds[shares[i]] += each;
68     }
69 
70     holds[owner] += value - each * shares.length;
71     return;
72   }
73 
74   function withdrawal() public whenNotPaused {
75     if (holds[msg.sender] > 0) {
76       uint256 v = holds[msg.sender];
77       holds[msg.sender] = 0;
78       msg.sender.transfer(v);
79     }
80   }
81 }
82 
83 contract ERC20Basic {
84   uint public totalSupply;
85   function balanceOf(address who) public constant returns (uint);
86   function transfer(address to, uint value) public;
87   event Transfer(address indexed from, address indexed to, uint value);
88 }
89 
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender) public constant returns (uint);
92   function transferFrom(address from, address to, uint value) public;
93   function approve(address spender, uint value) public;
94   event Approval(address indexed owner, address indexed spender, uint value);
95 }
96 
97 contract AirDrop is Share {
98   // owner => (token addr => token amount)  
99   mapping(address => mapping(address => uint256)) toDrop;
100 
101   uint256 public fee;
102 
103   function AirDrop (uint256 _fee) public {
104       fee = _fee;
105   }
106    
107   function setFee(uint256 _fee) public onlyOwner {
108     fee = _fee;
109   }
110 
111   function drop(address _token, address[] dsts, uint256 value) public payable whenNotPaused {
112     require(dsts.length > 0);
113     uint256 total = dsts.length * value;
114     assert(total / dsts.length == value);
115     require(msg.value >= fee);
116     
117     split(fee);
118     
119     uint256 i = 0;
120     if (_token == address(0)) {
121       //send ETH
122       require((fee + total) >= total);
123       require(msg.value >= (fee + total));
124       
125       while (i < dsts.length) {
126         dsts[i].transfer(value);        
127         i += 1;
128       }
129 
130     } else {
131       ERC20 erc20 = ERC20(_token);
132       require(erc20.allowance(msg.sender, this) >= total);
133 
134       while (i < dsts.length) {
135         erc20.transferFrom(msg.sender, dsts[i], value);
136         i += 1;
137       }
138     }
139   }
140 }