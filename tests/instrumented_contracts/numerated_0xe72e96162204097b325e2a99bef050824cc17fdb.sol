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
25     bool b_enableTransfer = true;
26     uint256 creationDate;
27     string public name;
28     string public symbol;
29     uint8 public decimals = 18;    
30     uint256 public totalSupply;
31     uint8 public tipoCongelamento = 0;
32         // 0 = unfreeze; 1 = frozen by 10 minutes; 2 = frozen by 30 minutes; 3 = frozen by 1 hour
33         // 4 = frozen by 2 hours; 5 = frozen by 1 day; 6 = frozen by 2 days
34         
35     event Transfer(address indexed from, address indexed to, uint256 value);        
36 
37     /* Initializes contract with initial supply tokens to the creator of the contract */
38     function MyTestToken (
39                            uint256 initialSupply,
40                            string tokenName,
41                            string tokenSymbol
42         ) owned() public 
43     {
44         totalSupply = initialSupply * 10 ** uint256(decimals);
45         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
46         creationDate = now;
47         name = tokenName;
48         symbol = tokenSymbol;
49     }
50 
51     /* Send coins */
52     function transfer2(address _to, uint256 _value) public
53     {
54         require(b_enableTransfer); 
55         //require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
56         //require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
57         
58         _transfer(_to, _value);
59     }
60 
61     function transfer(address _to, uint256 _value) public
62     {
63         // testa periodos de congelamento
64         // 0 = unfreeze; 1 = frozen by 10 minutes; 2 = frozen by 30 minutes; 3 = frozen by 1 hour
65         // 4 = frozen by 2 hours; 5 = frozen by 1 day; 6 = frozen by 2 days
66         if(tipoCongelamento == 0) // unfrozen
67         {
68             _transfer(_to, _value);
69         }
70         if(tipoCongelamento == 1) // 10 minutes
71         {
72             if(now >= creationDate + 10 * 1 minutes) _transfer(_to, _value);
73         }
74         if(tipoCongelamento == 2) // 30 minutes
75         {
76             if(now >= creationDate + 30 * 1 minutes) _transfer(_to, _value);
77         }        
78         if(tipoCongelamento == 3) // 1 hour
79         {
80             if(now >= creationDate + 1 * 1 hours) _transfer(_to, _value);
81         }        
82         if(tipoCongelamento == 4) // 2 hours
83         {
84             if(now >= creationDate + 2 * 1 hours) _transfer(_to, _value);
85         }        
86         if(tipoCongelamento == 5) // 1 day
87         {
88             if(now >= creationDate + 1 * 1 days) _transfer(_to, _value);
89         }        
90         if(tipoCongelamento == 6) // 2 days
91         {
92             if(now >= creationDate + 2 * 1 days) _transfer(_to, _value);
93         }        
94     }
95 
96     function freezingStatus() view public returns (string)
97     {
98         // 0 = unfreeze; 1 = frozen by 10 minutes; 2 = frozen by 30 minutes; 3 = frozen by 1 hour
99         // 4 = frozen by 2 hours; 5 = frozen by 1 day; 6 = frozen by 2 days
100         
101         if(tipoCongelamento == 0) return ( "Tokens free to transfer!");
102         if(tipoCongelamento == 1) return ( "Tokens frozen by 10 minutes.");
103         if(tipoCongelamento == 2) return ( "Tokens frozen by 30 minutes.");
104         if(tipoCongelamento == 3) return ( "Tokens frozen by 1 hour.");
105         if(tipoCongelamento == 4) return ( "Tokens frozen by 2 hours.");        
106         if(tipoCongelamento == 5) return ( "Tokens frozen by 1 day.");        
107         if(tipoCongelamento == 6) return ( "Tokens frozen by 2 days.");                
108 
109     }
110 
111     function setFreezingStatus(uint8 _mode) onlyOwner public
112     {
113         require(_mode>=0 && _mode <=6);
114         tipoCongelamento = _mode;
115     }
116 
117     function _transfer(address _to, uint256 _value) private 
118     {
119         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
120         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
121         
122         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
123         balanceOf[_to] += _value;                           // Add the same to the recipient
124         Transfer(msg.sender, _to, _value);
125     }
126     
127     function enableTransfer(bool _enableTransfer) onlyOwner public
128     {
129         b_enableTransfer = _enableTransfer;
130     }
131 }