1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract CrisCoin {
6     // Public variables of the token
7     string public constant name = "CrisCoin";
8     string public constant symbol = "CSX";
9     uint8 public constant decimals = 18;
10     uint256 public totalSupply;
11     address public owner;
12     uint256 public constant RATE = 1000;
13     
14     uint256 initialSupply = 100000;
15 
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Burn(address indexed from, uint256 value);
21 
22     function CrisCoin() public 
23     {
24         owner = msg.sender;
25         totalSupply = initialSupply * 10 ** uint256(decimals);
26         balanceOf[msg.sender] = totalSupply;
27     }
28     
29     function () public payable
30     {
31         createTokens();
32     }
33     
34     function createTokens() public payable
35     {
36         require( msg.value > 0 );
37         
38         require( msg.value * RATE > msg.value );
39         uint256 tokens = msg.value * RATE;
40         
41         require( balanceOf[msg.sender] + tokens > balanceOf[msg.sender] );
42         balanceOf[msg.sender] += tokens;
43         
44         require( totalSupply + tokens > totalSupply );
45         totalSupply += tokens;
46         
47         owner.transfer(msg.value);
48     }
49 
50     function _transfer(address _from, address _to, uint _value) internal 
51     {
52         require(_to != 0x0);
53         require(balanceOf[_from] >= _value);
54         require(balanceOf[_to] + _value > balanceOf[_to]);
55         
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         balanceOf[_from] -= _value;
58         balanceOf[_to] += _value;
59         Transfer(_from, _to, _value);
60         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
61     }
62 
63     function transfer(address _to, uint256 _value) public 
64     {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
69     {
70         require(_value <= allowance[_from][msg.sender]);
71         
72         allowance[_from][msg.sender] -= _value;
73         _transfer(_from, _to, _value);
74         
75         return true;
76     }
77 
78     function approve(address _spender, uint256 _value) public returns (bool success) 
79     {
80         allowance[msg.sender][_spender] = _value;
81         return true;
82     }
83 
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
85     {
86         tokenRecipient spender = tokenRecipient(_spender);
87         if (approve(_spender, _value)) 
88         {
89             spender.receiveApproval(msg.sender, _value, this, _extraData);
90             return true;
91         }
92     }
93 
94     function burn(uint256 _value) public returns (bool success)
95     {
96         require(balanceOf[msg.sender] >= _value);
97         
98         balanceOf[msg.sender] -= _value;
99         totalSupply -= _value;
100         Burn(msg.sender, _value);
101         
102         return true;
103     }
104 
105     function burnFrom(address _from, uint256 _value) public returns (bool success) 
106     {
107         require(balanceOf[_from] >= _value);
108         require(_value <= allowance[_from][msg.sender]);
109         
110         balanceOf[_from] -= _value;
111         allowance[_from][msg.sender] -= _value;
112         totalSupply -= _value;
113         Burn(_from, _value);
114         
115         return true;
116     }
117 }