1 /**
2  *Submitted for verification at Etherscan.io on 2023-02-05
3 */
4 
5 // SPDX-License-Identifier: MIT
6 /**
7 
8 Shinjiru AI
9 
10 Shinjiru AI is a token on the Ethereum Smart Chain that never stops growing through 
11 TRUE deflationary techniques and further income generation for its ecosystem.
12 
13 Tax: 5/5 
14 -With ETH Trending
15 -Roadmap
16 -Lock LP
17 -Renounce Ownership
18 
19 -Website: https://singularitynet.io/
20 -Telegram: https://t.me/singularitynet
21 -Twitter: https://twitter.com/singularitynet
22 **/
23 //SPDX-License-Identifier: MITpragma solidity ^0.4.16;
24  
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
26  
27 contract TokenERC20 {
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31     uint256 public totalSupply;
32  
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35  
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38     event Burn(address indexed from, uint256 value);
39  
40  
41     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);
43         balanceOf[msg.sender] = totalSupply;
44         name = tokenName;
45         symbol = tokenSymbol;
46     }
47  
48  
49     function _transfer(address _from, address _to, uint _value) internal {
50         require(_to != 0x0);
51         require(balanceOf[_from] >= _value);
52         require(balanceOf[_to] + _value > balanceOf[_to]);
53         uint previousBalances = balanceOf[_from] + balanceOf[_to];
54         balanceOf[_from] -= _value;
55         balanceOf[_to] += _value;
56         Transfer(_from, _to, _value);
57         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
58     }
59  
60     function transfer(address _to, uint256 _value) public returns (bool) {
61         _transfer(msg.sender, _to, _value);
62         return true;
63     }
64  
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         require(_value <= allowance[_from][msg.sender]);     // Check allowance
67         allowance[_from][msg.sender] -= _value;
68         _transfer(_from, _to, _value);
69         return true;
70     }
71  
72     function approve(address _spender, uint256 _value) public
73         returns (bool success) {
74         allowance[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78  
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
80         tokenRecipient spender = tokenRecipient(_spender);
81         if (approve(_spender, _value)) {
82             spender.receiveApproval(msg.sender, _value, this, _extraData);
83             return true;
84         }
85     }
86  
87     function burn(uint256 _value) public returns (bool success) {
88         require(balanceOf[msg.sender] >= _value);
89         balanceOf[msg.sender] -= _value;
90         totalSupply -= _value;
91         Burn(msg.sender, _value);
92         return true;
93     }
94  
95     function burnFrom(address _from, uint256 _value) public returns (bool success) {
96         require(balanceOf[_from] >= _value);
97         require(_value <= allowance[_from][msg.sender]);
98         balanceOf[_from] -= _value;
99         allowance[_from][msg.sender] -= _value;
100         totalSupply -= _value;
101         Burn(_from, _value);
102         return true;
103     }
104 }