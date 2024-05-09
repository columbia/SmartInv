1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint);
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function transfer(address to, uint tokens) public returns (bool success);
7 
8     
9     //function allowance(address tokenOwner, address spender) public view returns (uint remaining);
10     //function approve(address spender, uint tokens) public returns (bool success);
11     //function transferFrom(address from, address to, uint tokens) public returns (bool success);
12     
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     //event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     emit OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37 }
38 
39 
40 contract ZCOR is ERC20Interface, Ownable{
41     string public name = "ZROCOR";
42     string public symbol = "ZCOR";
43     uint public decimals = 0;
44     
45     uint public supply;
46     address public founder;
47     
48     mapping(address => uint) public balances;
49     mapping(uint => mapping(address => uint)) public timeLockedBalances;
50     mapping(uint => address[]) public lockedAddresses;
51 
52 
53  event Transfer(address indexed from, address indexed to, uint tokens);
54 
55 
56     constructor() public{
57         supply = 10000000000;
58         founder = msg.sender;
59         balances[founder] = supply;
60     }
61     
62     // transfer locked balance to an address
63     function transferLockedBalance(uint _category, address _to, uint _value) public onlyOwner returns (bool success) {
64         require(balances[msg.sender] >= _value && _value > 0);
65         lockedAddresses[_category].push(_to);
66         balances[msg.sender] -= _value;
67         timeLockedBalances[_category][_to] += _value;
68         emit Transfer(msg.sender, _to, _value);
69         return true;
70     }
71     
72     // unlock category of locked address
73     function unlockBalance(uint _category) public onlyOwner returns (bool success) {
74         uint _length = lockedAddresses[_category].length;
75         address _addr;
76         uint _value = 0;
77         for(uint i = 0; i< _length; i++) {
78             _addr = lockedAddresses[_category][i];
79             _value = timeLockedBalances[_category][_addr];
80             balances[_addr] += _value;
81             timeLockedBalances[_category][_addr] = 0;
82         }
83         delete lockedAddresses[_category];
84         return true;
85     }
86     
87     //view locked balance
88     function lockedBalanceOf(uint level, address _address) public view returns (uint balance) {
89         return timeLockedBalances[level][_address];
90     }
91     
92     function totalSupply() public view returns (uint){
93         return supply;
94     }
95     
96     function balanceOf(address tokenOwner) public view returns (uint balance){
97         return balances[tokenOwner];
98     }
99      
100      
101     //transfer from the owner balance to another address
102     function transfer(address to, uint tokens) public returns (bool success){
103         require(balances[msg.sender] >= tokens && tokens > 0);
104          
105         balances[to] += tokens;
106         balances[msg.sender] -= tokens;
107         emit Transfer(msg.sender, to, tokens);
108         return true;
109     }
110      
111      
112     function burn(uint256 _value) public onlyOwner returns (bool success) {
113         require(balances[founder] >= _value);   // Check if the sender has enough
114         balances[founder] -= _value;            // Subtract from the sender
115         supply -= _value;                      // Updates totalSupply
116         return true;
117     }
118 
119     function mint(uint256 _value) public onlyOwner returns (bool success) {
120         require(balances[founder] >= _value);   // Check if the sender has enough
121         balances[founder] += _value;            // Add to the sender
122         supply += _value;                      // Updates totalSupply
123         return true;
124     }
125      
126 }