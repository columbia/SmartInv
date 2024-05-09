1 pragma solidity ^0.4.12;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public
7     {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner
12     {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function changeOwnership(address newOwner) public onlyOwner
18     {
19         owner = newOwner;
20     }
21 }
22 
23 contract MyToken is owned {
24     
25     string public standard = 'NCMT 1.0';
26     string public name;
27     string public symbol;
28     uint8 public decimals;
29     uint256 public totalSupply;
30 
31     
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34     mapping (address => bool) public frozenAccount;
35 
36     
37     function MyToken  () public {
38         balanceOf[msg.sender] = 7998000000000000000000000000;
39         totalSupply =7998000000000000000000000000;
40         name = 'NCM Govuro Forest Token';
41         symbol = 'NCMT';
42         decimals = 18;
43     }
44 
45 
46     
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     
50     event FrozenFunds(address target, bool frozen);
51 
52     
53     event Burn(address indexed from, uint256 value);
54 
55     
56     function transfer(address _to, uint256 _value) public
57     returns (bool success)
58     {
59         require(_to != 0x0);
60         require(balanceOf[msg.sender] >= _value);
61         require(!frozenAccount[msg.sender]);
62         balanceOf[msg.sender] -= _value;
63         balanceOf[_to] += _value;
64         Transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     
69    function mintToken(address target, uint256 mintedAmount)  public onlyOwner
70    {
71         balanceOf[target] += mintedAmount;
72         totalSupply += mintedAmount;
73         Transfer(0, this, mintedAmount);
74         Transfer(this, target, mintedAmount);
75    }
76 
77     
78     function freezeAccount(address target, bool freeze)  public onlyOwner
79     {
80         frozenAccount[target] = freeze;
81         FrozenFunds(target, freeze);
82     }
83 
84     
85     function burn(uint256 _value)  public onlyOwner
86     returns (bool success)
87     {
88         require(balanceOf[msg.sender] >= _value);
89         balanceOf[msg.sender] -= _value;
90         totalSupply -= _value;
91         Burn(msg.sender, _value);
92         return true;
93     }
94 
95     
96     function burnFrom(address _from, uint256 _value)  public onlyOwner
97     returns (bool success)
98     {
99         require(balanceOf[_from] >= _value);
100         require(_value <= allowance[_from][msg.sender]);
101         balanceOf[_from] -= _value;
102         totalSupply -= _value;
103         Burn(_from, _value);
104         return true;
105     }
106 }