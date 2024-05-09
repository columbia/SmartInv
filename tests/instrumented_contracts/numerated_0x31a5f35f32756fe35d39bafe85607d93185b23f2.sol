1 pragma solidity ^0.4.16;
2 
3 
4 /*                                                                        
5  *  110010101000011000110110001011101010011000100110111110101111101000110001 
6  *  011111110010000101101010011000101011111100001111001100100100111001110110 
7  *  101010000001101110001110110001010101010000111100101011100011111011000011 
8  *  010100100010101011001011010011001001101010001011110000111000111100101101 
9  *  011010100111111010111100011000011001011010100100101111010001001001011110 
10  *  000010000011000100111111000111010101000101111000101100111111101111010001 
11  *  1001000101011110 
12  * "GNNM.110100i"
13  */
14 
15 
16 
17 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
18 
19 contract GNNM {
20     // 001101100010111010100110001
21     string public name;
22     string public symbol;
23     uint8 public decimals = 8;
24     // 18 decimals is the strongly suggested default, avoid changing it
25     uint256 public totalSupply;
26 
27     // 011010100010111100001
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     // GNNM13
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     
34     // 1010100010111
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37     // GNNM8
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * 00000000000000
42      * 10111001010111
43      */
44     function GNNM(
45         uint256 initialSupply,
46         string tokenName,
47         string tokenSymbol
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);  // 
50         balanceOf[msg.sender] = totalSupply;                // 
51         name = tokenName;                                   // 
52         symbol = tokenSymbol;                               // .1
53     }
54 
55     /**
56      * 1100100011010110111
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // 3be012629
60         require(_to != 0x0);
61         // 0e836
62         require(balanceOf[_from] >= _value);
63         // 616c74656
64         require(balanceOf[_to] + _value >= balanceOf[_to]);
65         // 9d2dc2e9760
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // sy00
68         balanceOf[_from] -= _value;
69         // 2xdffff
70         balanceOf[_to] += _value;
71         emit Transfer(_from, _to, _value);
72         // 20e83684
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * GNNM4
78      */
79     function transfer(address _to, uint256 _value) public returns (bool success) {
80         _transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     /**
85      * GNNM7
86      * GNNM""
87      */
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         require(_value <= allowance[_from][msg.sender]);     // GNNM0
90         allowance[_from][msg.sender] -= _value;
91         _transfer(_from, _to, _value);
92         return true;
93     }
94 
95 
96     function approve(address _spender, uint256 _value) public
97         returns (bool success) {
98         allowance[msg.sender][_spender] = _value;
99         emit Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103 
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
105         public
106         returns (bool success) {
107         tokenRecipient spender = tokenRecipient(_spender);
108         if (approve(_spender, _value)) {
109             spender.receiveApproval(msg.sender, _value, this, _extraData);
110             return true;
111         }
112     }
113 
114 
115     function burn(uint256 _value) public returns (bool success) {
116         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
117         balanceOf[msg.sender] -= _value;            // Subtract from the sender
118         totalSupply -= _value;                      // Updates totalSupply
119         emit Burn(msg.sender, _value);
120         return true;
121     }
122 
123     /**
124      * GNNM11
125      */
126     function burnFrom(address _from, uint256 _value) public returns (bool success) {
127         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
128         require(_value <= allowance[_from][msg.sender]);    // Check allowance
129         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
130         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
131         totalSupply -= _value;                              // Update totalSupply
132         emit Burn(_from, _value);
133         return true;
134     }
135 }