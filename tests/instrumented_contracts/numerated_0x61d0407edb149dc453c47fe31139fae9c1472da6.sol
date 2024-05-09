1 pragma solidity ^ 0.4.15;
2 
3 /**
4 *library name : SafeMath
5 *purpose : be the library for the smart contract for the swap between the godz and ether
6 *goal : to achieve the secure basic math operations
7 */
8 library SafeMath {
9 
10   /*function name : mul*/
11   /*purpose : be the funcion for safe multiplicate*/
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     /*assert(a == 0 || c / a == b);*/
15     return c;
16   }
17 
18   /*function name : div*/
19   /*purpose : be the funcion for safe division*/
20   function div(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a / b;
22     return c;
23   }
24 
25   /*function name : sub*/
26   /*purpose : be the funcion for safe substract*/
27   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
28     /*assert(b <= a);*/
29     return a - b;
30   }
31 
32   /*function name : add*/
33   /*purpose : be the funcion for safe sum*/
34   function add(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a + b;
36     /*assert(c >= a);*/
37     return c;
38   }
39 }
40 
41 /**
42 *contract name : tokenRecipient
43 */
44 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
45 
46 /**
47 *contract name : Token
48 */
49 contract Token {
50     /*using the secure math library for basic math operations*/
51     using SafeMath for uint256;
52 
53     /* Public variables of the token */
54     string public standard = 'DSCS.GODZ.TOKEN';
55     string public name;
56     string public symbol;
57     uint8 public decimals;
58     uint256 public totalSupply;
59 
60     /* This creates an array with all balances */
61     mapping (address => uint256) public balanceOf;
62     mapping (address => mapping (address => uint256)) public allowance;
63 
64     /* This generates a public event on the blockchain that will notify clients */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /* Initializes contract with initial supply tokens to the creator of the contract */
68     function Token(
69         uint256 initialSupply,
70         string tokenName,
71         uint8 decimalUnits,
72         string tokenSymbol
73         ) {
74         balanceOf[msg.sender] = initialSupply;                  /* Give the creator all initial tokens*/
75         totalSupply = initialSupply;                            /* Update total supply*/
76         name = tokenName;                                       /* Set the name for display purposes*/
77         symbol = tokenSymbol;                                   /* Set the symbol for display purposes*/
78         decimals = decimalUnits;                                /* Amount of decimals for display purposes*/
79     }
80 
81     /* Send coins */
82     function transfer(address _to, uint256 _value) {
83         if (_to == 0x0) revert();                               /* Prevent transfer to 0x0 address. Use burn() instead*/
84         if (balanceOf[msg.sender] < _value) revert();           /* Check if the sender has enough*/
85         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); /* Check for overflows*/
86         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                        /* Subtract from the sender*/
87         balanceOf[_to] = balanceOf[_to].add(_value);                               /* Add the same to the recipient*/
88         Transfer(msg.sender, _to, _value);                      /* Notify anyone listening that this transfer took place*/
89     }
90 
91     /* Allow another contract to spend some tokens in your behalf */
92     function approve(address _spender, uint256 _value)
93         returns (bool success) {
94         allowance[msg.sender][_spender] = _value;
95         return true;
96     }
97 
98     /* Approve and then communicate the approved contract in a single tx */
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
100         returns (bool success) {
101         tokenRecipient spender = tokenRecipient(_spender);
102         if (approve(_spender, _value)) {
103             spender.receiveApproval(msg.sender, _value, this, _extraData);
104             return true;
105         }
106     }
107 
108     /* A contract attempts to get the coins but transfer from the origin*/
109     function transferFromOrigin(address _to, uint256 _value)  returns (bool success) {
110         address origin = tx.origin;
111         if (origin == 0x0) revert();
112         if (_to == 0x0) revert();                                /* Prevent transfer to 0x0 address.*/
113         if (balanceOf[origin] < _value) revert();                /* Check if the sender has enough*/
114         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  /* Check for overflows*/
115         balanceOf[origin] = balanceOf[origin].sub(_value);       /* Subtract from the sender*/
116         balanceOf[_to] = balanceOf[_to].add(_value);             /* Add the same to the recipient*/
117         return true;
118     }
119 
120     /* A contract attempts to get the coins */
121     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
122         if (_to == 0x0) revert();                                /* Prevent transfer to 0x0 address.*/
123         if (balanceOf[_from] < _value) revert();                 /* Check if the sender has enough*/
124         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  /* Check for overflows*/
125         if (_value > allowance[_from][msg.sender]) revert();     /* Check allowance*/
126         balanceOf[_from] = balanceOf[_from].sub(_value);                              /* Subtract from the sender*/
127         balanceOf[_to] = balanceOf[_to].add(_value);                                /* Add the same to the recipient*/
128         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
129         Transfer(_from, _to, _value);
130         return true;
131     }
132 
133 }