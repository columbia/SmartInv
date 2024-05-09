1 pragma solidity ^0.4.16;
2 
3     contract owned {
4         address public owner;
5 
6         function owned() public {
7             owner = msg.sender;
8         }
9 
10         modifier onlyOwner {
11             require(msg.sender == owner);
12             _;
13         }
14 
15         function transferOwnership(address newOwner) onlyOwner public {
16             owner = newOwner;
17         }
18     }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract MyTestToken is owned {
23     /* This creates an array with all balances */
24     mapping (address => uint256) public balanceOf;
25     bool private b_enableTransfer = true;
26     uint256 public creationDate;
27     string public name;
28     string public symbol;
29     uint8 public decimals = 18;    
30     uint256 public totalSupply;
31     uint8 public tipoCongelamento = 0;
32         // 0 = unfreeze; 1 = frozen by 10 minutes; 2 = frozen by 30 minutes; 3 = frozen by 1 hour
33         // 4 = frozen by 2 hours; 5 = frozen by 1 day; 6 = frozen by 2 days
34 
35     /* Initializes contract with initial supply tokens to the creator of the contract */
36     function MyTestToken (
37                            uint256 initialSupply,
38                            string tokenName,
39                            string tokenSymbol
40         ) owned() public 
41     {
42         totalSupply = initialSupply * 10 ** uint256(decimals);
43         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
44         creationDate = now;
45         name = tokenName;
46         symbol = tokenSymbol;
47     }
48 
49     /* Send coins */
50     function transfer2(address _to, uint256 _value) public
51     {
52         require(b_enableTransfer); 
53         
54         
55         _transfer(_to, _value);
56     }
57 
58     function transfer(address _to, uint256 _value) public
59     {
60         // testa periodos de congelamento
61         // 0 = unfreeze; 1 = frozen by 10 minutes; 2 = frozen by 30 minutes; 3 = frozen by 1 hour
62         // 4 = frozen by 2 hours; 5 = frozen by 1 day; 6 = frozen by 2 days
63         if(tipoCongelamento == 0) // unfrozen
64         {
65             _transfer(_to, _value);
66         }
67         if(tipoCongelamento == 1) // 10 minutes
68         {
69             if(now >= creationDate + 10 * 1 minutes) _transfer(_to, _value);
70         }
71         if(tipoCongelamento == 2) // 30 minutes
72         {
73             if(now >= creationDate + 30 * 1 minutes) _transfer(_to, _value);
74         }        
75         if(tipoCongelamento == 3) // 1 hour
76         {
77             if(now >= creationDate + 1 * 1 hours) _transfer(_to, _value);
78         }        
79         if(tipoCongelamento == 4) // 2 hours
80         {
81             if(now >= creationDate + 2 * 1 hours) _transfer(_to, _value);
82         }        
83         if(tipoCongelamento == 5) // 1 day
84         {
85             if(now >= creationDate + 1 * 1 days) _transfer(_to, _value);
86         }        
87         if(tipoCongelamento == 6) // 2 days
88         {
89             if(now >= creationDate + 2 * 1 days) _transfer(_to, _value);
90         }        
91     }
92 
93     function freezingStatus() view public returns (string)
94     {
95         // 0 = unfreeze; 1 = frozen by 10 minutes; 2 = frozen by 30 minutes; 3 = frozen by 1 hour
96         // 4 = frozen by 2 hours; 5 = frozen by 1 day; 6 = frozen by 2 days
97         
98         if(tipoCongelamento == 0) return ( "Tokens free to transfer!");
99         if(tipoCongelamento == 1) return ( "Tokens frozen by 10 minutes.");
100         if(tipoCongelamento == 2) return ( "Tokens frozen by 30 minutes.");
101         if(tipoCongelamento == 3) return ( "Tokens frozen by 1 hour.");
102         if(tipoCongelamento == 4) return ( "Tokens frozen by 2 hours.");        
103         if(tipoCongelamento == 5) return ( "Tokens frozen by 1 day.");        
104         if(tipoCongelamento == 6) return ( "Tokens frozen by 2 days.");                
105 
106     }
107 
108     function setFreezingStatus(uint8 _mode) onlyOwner public
109     {
110         require(_mode>=0 && _mode <=6);
111         tipoCongelamento = _mode;
112     }
113 
114     function _transfer(address _to, uint256 _value) private 
115     {
116         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
117         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
118         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
119         balanceOf[_to] += _value;                           // Add the same to the recipient
120     }
121     
122     function enableTransfer(bool _enableTransfer) onlyOwner public
123     {
124         b_enableTransfer = _enableTransfer;
125     }
126 }