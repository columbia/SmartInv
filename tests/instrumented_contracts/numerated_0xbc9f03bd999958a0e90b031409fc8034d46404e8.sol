1 pragma solidity ^0.4.16;
2 
3     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5     contract OEO {
6         string public name;
7         string public symbol;
8         uint8 public decimals = 18;  
9         uint256 public totalSupply;
10 
11         mapping (address => uint256) public balanceOf;
12         
13         mapping (address => mapping (address => uint256)) public allowance;
14 
15         
16         event Transfer(address indexed from, address indexed to, uint256 value);
17 
18         
19         event Burn(address indexed from, uint256 value);
20 
21         /**
22          * 
23          */
24         function OEO (uint256 initialSupply, string tokenName, string tokenSymbol) public {
25             totalSupply = initialSupply * 10 ** uint256(decimals);  
26             balanceOf[msg.sender] = totalSupply;                
27             name = tokenName;                                   
28             symbol = tokenSymbol;                               
29         }
30 
31         /**
32          * 
33          */
34         function _transfer(address _from, address _to, uint _value) internal {
35             // 
36             require(_to != 0x0);
37             // 
38             require(balanceOf[_from] >= _value);
39             // 
40             require(balanceOf[_to] + _value > balanceOf[_to]);
41 
42             // 
43             uint previousBalances = balanceOf[_from] + balanceOf[_to];
44             // 
45             balanceOf[_from] -= _value;
46             // 
47             balanceOf[_to] += _value;
48             Transfer(_from, _to, _value);
49 
50             // 
51             assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52         }
53 
54 
55         function transfer(address _to, uint256 _value) public {
56             _transfer(msg.sender, _to, _value);
57         }
58 
59 
60         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61             require(_value <= allowance[_from][msg.sender]);     // Check allowance
62             allowance[_from][msg.sender] -= _value;
63             _transfer(_from, _to, _value);
64             return true;
65         }
66 
67 
68         function approve(address _spender, uint256 _value) public
69             returns (bool success) {
70             allowance[msg.sender][_spender] = _value;
71             return true;
72         }
73 
74 
75         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
76             public
77             returns (bool success) {
78             tokenRecipient spender = tokenRecipient(_spender);
79             if (approve(_spender, _value)) {
80                 // 通知合约
81                 spender.receiveApproval(msg.sender, _value, this, _extraData);
82                 return true;
83             }
84         }
85 
86 
87         function burn(uint256 _value) public returns (bool success) {
88             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
89             balanceOf[msg.sender] -= _value;            // Subtract from the sender
90             totalSupply -= _value;                      // Updates totalSupply
91             Burn(msg.sender, _value);
92             return true;
93         }
94 
95 
96         function burnFrom(address _from, uint256 _value) public returns (bool success) {
97             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
98             require(_value <= allowance[_from][msg.sender]);    // Check allowance
99             balanceOf[_from] -= _value;                         // Subtract from the targeted balance
100             allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
101             totalSupply -= _value;                              // Update totalSupply
102             Burn(_from, _value);
103             return true;
104         }
105     }