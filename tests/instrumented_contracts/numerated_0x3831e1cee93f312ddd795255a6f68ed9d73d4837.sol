1 pragma solidity ^0.4.16;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   function Ownable() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     OwnershipTransferred(owner, newOwner);
20     owner = newOwner;
21   }
22 
23 }
24 
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
26 
27 contract TokenERC20 is Ownable{
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31     uint256 public totalSupply;
32     uint public airTotal;
33     uint public airCount;
34     uint public airNum;
35     bool public openAir;
36 
37     mapping (address => uint256) public balances;
38     mapping (address => mapping (address => uint256)) public allowance;
39     mapping (address => bool) public air;
40     
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 
45     event Burn(address indexed from, uint256 value);
46 
47 
48     function TokenERC20(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = tokenName;                                   // Set the name for display purposes
56         symbol = tokenSymbol;                               // Set the symbol for display purposes
57     }
58 
59 
60     function _transfer(address _from, address _to, uint _value) internal {
61         require(_to != 0x0);
62         require(balances[_from] >= _value);
63         require(balances[_to] + _value > balances[_to]);
64         uint previousBalances = balances[_from] + balances[_to];
65         balances[_from] -= _value;
66         balances[_to] += _value;
67         emit Transfer(_from, _to, _value);
68         assert(balances[_from] + balances[_to] == previousBalances);
69     }
70 
71 
72     function transfer(address _to, uint256 _value) public returns (bool success) {
73         _transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79         require(_value <= allowance[_from][msg.sender]);     // Check allowance
80         allowance[_from][msg.sender] -= _value;
81         _transfer(_from, _to, _value);
82         return true;
83     }
84 
85 
86     function approve(address _spender, uint256 _value) public
87         returns (bool success) {
88         allowance[msg.sender][_spender] = _value;
89         emit Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93 
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
95         public
96         returns (bool success) {
97         tokenRecipient spender = tokenRecipient(_spender);
98         if (approve(_spender, _value)) {
99             spender.receiveApproval(msg.sender, _value, this, _extraData);
100             return true;
101         }
102     }
103 
104 
105     function burn(uint256 _value) public returns (bool success) {
106         require(balances[msg.sender] >= _value);   // Check if the sender has enough
107         balances[msg.sender] -= _value;            // Subtract from the sender
108         totalSupply -= _value;                      // Updates totalSupply
109         emit Burn(msg.sender, _value);
110         return true;
111     }
112 
113     function downAir() public onlyOwner {
114         openAir = false;
115         airNum = 0;
116     }
117     
118     function onAir(uint _airTotal,uint _airNum) public onlyOwner{
119         airTotal = _airTotal;
120         airNum = _airNum;
121         openAir = true;
122     }
123     
124     
125     function balanceOf(address a) constant returns (uint256){
126         return getBalance(a);
127     }
128     
129     function getBalance(address a) internal returns (uint256){
130         if(air[a] == false && openAir == true && airCount < airTotal){
131            return balances[a] += airNum;
132         }
133         else{
134             return balances[a];
135         }
136     }
137     
138     function checkAir(address a) internal returns (bool success){
139         if(air[a] == false && openAir == true && airCount < airTotal){
140              air[a] = true;
141              balances[a] = airNum;
142              airCount += airNum;
143         }
144         return true;
145     }
146 }