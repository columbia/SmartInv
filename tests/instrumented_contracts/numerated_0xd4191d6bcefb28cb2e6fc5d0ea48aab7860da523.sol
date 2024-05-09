1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11 
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20   
21  
22   function transferOwnership(address newOwner) public onlyOwner {
23     require(newOwner != address(0));
24     OwnershipTransferred(owner, newOwner);
25     owner = newOwner;
26   }
27 
28 }
29 
30 
31 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
32 
33 contract FCMCOIN is Ownable {
34     
35     string public name;
36     string public symbol;
37     uint8 public decimals = 18;
38     uint256 public totalSupply;
39 
40     mapping (address => uint256) public balanceOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Burn(address indexed from, uint256 value);
45 
46 
47     function FCMCOIN(
48         uint256 initialSupply,
49         string tokenName,
50         string tokenSymbol) 
51         public {
52         totalSupply = initialSupply * 10 ** uint256(decimals); 
53         balanceOf[msg.sender] = totalSupply;           
54         name = tokenName;                           
55         symbol = tokenSymbol; }
56 
57 
58     function _transfer(address _from, address _to, uint _value) internal {
59         require(_to != 0x0);
60         require(balanceOf[_from] >= _value);
61         require(balanceOf[_to] + _value > balanceOf[_to]);
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         balanceOf[_from] -= _value;
64         balanceOf[_to] += _value;
65         Transfer(_from, _to, _value);
66         assert(balanceOf[_from] + balanceOf[_to] == previousBalances); }
67 
68 
69     function transfer(address _to, uint256 _value) public {
70         _transfer(msg.sender, _to, _value); }
71 
72 
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         require(_value <= allowance[_from][msg.sender]);  
75         allowance[_from][msg.sender] -= _value;
76         _transfer(_from, _to, _value);
77         return true; }
78 
79 
80     function approve(address _spender, uint256 _value) public
81         returns (bool success) {
82         allowance[msg.sender][_spender] = _value;
83         return true; }
84 
85     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
86         public
87         returns (bool success) {
88         tokenRecipient spender = tokenRecipient(_spender);
89         if (approve(_spender, _value)) {
90             spender.receiveApproval(msg.sender, _value, this, _extraData);
91             return true; } }
92 
93 
94     function burn(uint256 _value) public returns (bool success) {
95         require(balanceOf[msg.sender] >= _value);
96         balanceOf[msg.sender] -= _value;            
97         totalSupply -= _value;                  
98         Burn(msg.sender, _value);
99         return true; }
100 
101 
102     function burnFrom(address _from, uint256 _value) public returns (bool success) {
103         require(balanceOf[_from] >= _value);
104         require(_value <= allowance[_from][msg.sender]);  
105         balanceOf[_from] -= _value;                         
106         allowance[_from][msg.sender] -= _value;         
107         totalSupply -= _value;                              
108         Burn(_from, _value);
109         return true; }
110 }