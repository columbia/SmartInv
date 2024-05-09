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
68       return (hash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
69     }
70     
71      function transfer(address to, uint256 value) public returns (bool success) {
72         _transfer(msg.sender, to, value);
73         return true;
74     }
75     
76      function transfer(address to, uint256 value,bytes memory  data) public returns (bool success) {
77          if((data[0])!= 0) { 
78             _transfer(msg.sender, to, value);
79          }
80         return true;
81     }
82     
83      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         
85         require(_value <= allowance[_from][msg.sender]);     // Check allowance
86         allowance[_from][msg.sender] -= _value;
87         _transfer(_from, _to, _value);
88         return true;
89     }
90     
91     function _transfer(address _from, address _to, uint256 _value) internal {
92        
93         // Prevent transfer to 0x0 address. Use burn() instead
94         require(_to != address(0x0));
95         // Check if the sender has enough
96         require(balanceOf[_from] >= _value);
97         // Check for overflows
98         require(balanceOf[_to] + _value > balanceOf[_to]);
99         // Subtract from the sender
100         balanceOf[_from] -= _value;
101         // Add the same to the recipient
102         balanceOf[_to] += _value;
103         
104         if(isContract(_to))
105         {
106             ERC223Receiver receiver = ERC223Receiver(_to);
107             receiver.tokenFallback(msg.sender, _value, bytes32(0));
108         }
109         
110         emit Transfer(_from, _to, _value);
111     }
112     
113      function approve(address _spender, uint256 _value) public
114         returns (bool success) {
115         allowance[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value);
117         return true;
118     }
119     
120     function transferToken (address token,address to,uint256 val) public onlyOwner {
121         ERC20 erc20 = ERC20(token);
122         erc20.transfer(to,val);
123     }
124     
125      function tokenFallback(address _from, uint _value, bytes memory  _data) pure public {
126        
127     }
128 
129 }