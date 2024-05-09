1 pragma solidity ^0.4.25;
2 
3 /******************************************/
4 /*       Netkiller Mini TOKEN             */
5 /******************************************/
6 /* Author netkiller <netkiller@msn.com>   */
7 /* Home http://www.netkiller.cn           */
8 /* Version 2018-09-26 Test Token          */
9 /******************************************/
10 
11 contract NetkillerTestToken {
12     address public owner;
13 
14     string public name;
15     string public symbol;
16     uint public decimals;
17     uint256 public totalSupply;
18 
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25 
26     constructor(
27         uint256 initialSupply,
28         string tokenName,
29         string tokenSymbol,
30         uint decimalUnits
31     ) public {
32         owner = msg.sender;
33         name = tokenName; 
34         symbol = tokenSymbol; 
35         decimals = decimalUnits;
36         totalSupply = initialSupply * 10 ** uint256(decimals); 
37         balanceOf[msg.sender] = totalSupply;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44     function setSupply(uint256 _initialSupply) onlyOwner public{
45         totalSupply = _initialSupply * 10 ** uint256(decimals);
46     }
47     function setName(string _name) onlyOwner public{
48         name = _name;
49     }
50     function setSymbol(string _symbol) onlyOwner public{
51         symbol = _symbol;
52     }
53     function setDecimals(uint _decimals) onlyOwner public{
54         decimals = _decimals;
55     }
56 
57     function transferOwnership(address newOwner) onlyOwner public {
58         if (newOwner != address(0)) {
59             owner = newOwner;
60         }
61     }
62  
63     function _transfer(address _from, address _to, uint _value) internal {
64         require (_to != address(0));                        // Prevent transfer to 0x0 address. Use burn() instead
65         require (balanceOf[_from] >= _value);               // Check if the sender has enough
66         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
67         balanceOf[_from] -= _value;                         // Subtract from the sender
68         balanceOf[_to] += _value;                           // Add the same to the recipient
69         emit Transfer(_from, _to, _value);
70     }
71 
72     function transfer(address _to, uint256 _value) public returns (bool success){
73         _transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         require(_value <= allowance[_from][msg.sender]);     // Check allowance
79         allowance[_from][msg.sender] -= _value;
80         _transfer(_from, _to, _value);
81         return true;
82     }
83 
84     function approve(address _spender, uint256 _value) public returns (bool success) {
85         allowance[msg.sender][_spender] = _value;
86         emit Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 }