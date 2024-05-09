1 pragma solidity ^0.5.6;
2 
3 contract owned {
4     address payable public owner;
5 
6     constructor () public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address payable newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18     
19     function() external payable  {
20     }
21     
22      function withdraw() onlyOwner public {
23         owner.transfer(address(this).balance);
24     }
25 }
26 
27 
28 
29 
30 interface ERC20 {
31   function transfer(address receiver, uint256 value) external returns (bool ok);
32 }
33 
34 
35 interface ERC223Receiver {
36     function tokenFallback(address _from, uint _value, bytes32 _data) external ;
37 }
38 
39 
40 
41 contract SaTT is owned,ERC20 {
42 
43     uint8 public constant decimals = 18;
44     uint256 public constant totalSupply = 20000000000000000000000000000; // 20 billions and 18 decimals
45     string public constant symbol = "SATT";
46     string public constant name = "Smart Advertising Transaction Token";
47     
48 
49     
50     mapping (address => uint256) public balanceOf;
51     mapping (address => mapping (address => uint256)) public allowance;
52 
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
55     
56    
57     constructor () public {
58         balanceOf[msg.sender] = totalSupply;               
59     }
60     
61      function isContract(address _addr) internal view returns (bool is_contract) {
62       bytes32 hash;
63      
64       assembly {
65             //retrieve the size of the code on target address, this needs assembly
66             hash := extcodehash(_addr)
67       }
68       return (hash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 && hash != bytes32(0));
69      
70     }
71     
72      function transfer(address to, uint256 value) public returns (bool success) {
73         _transfer(msg.sender, to, value);
74         return true;
75     }
76     
77      function transfer(address to, uint256 value,bytes memory  data) public returns (bool success) {
78          if((data[0])!= 0) { 
79             _transfer(msg.sender, to, value);
80          }
81         return true;
82     }
83     
84      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         
86         require(_value <= allowance[_from][msg.sender]);     // Check allowance
87         allowance[_from][msg.sender] -= _value;
88         _transfer(_from, _to, _value);
89         return true;
90     }
91     
92     function _transfer(address _from, address _to, uint256 _value) internal {
93        
94         // Prevent transfer to 0x0 address. Use burn() instead
95         require(_to != address(0x0));
96         // Check if the sender has enough
97         require(balanceOf[_from] >= _value);
98         // Check for overflows
99         require(balanceOf[_to] + _value > balanceOf[_to]);
100         // Subtract from the sender
101         balanceOf[_from] -= _value;
102         // Add the same to the recipient
103         balanceOf[_to] += _value;
104         
105         if(isContract(_to))
106         {
107             ERC223Receiver receiver = ERC223Receiver(_to);
108             receiver.tokenFallback(msg.sender, _value, bytes32(0));
109         }
110         
111         emit Transfer(_from, _to, _value);
112     }
113     
114      function approve(address _spender, uint256 _value) public
115         returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120     
121     function transferToken (address token,address to,uint256 val) public onlyOwner {
122         ERC20 erc20 = ERC20(token);
123         erc20.transfer(to,val);
124     }
125     
126      function tokenFallback(address _from, uint _value, bytes memory  _data) pure public {
127        
128     }
129 
130 }