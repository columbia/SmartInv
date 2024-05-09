1 /* version metahashtoken 0.1.4 RC */
2 pragma solidity ^0.4.18;
3 contract metahashtoken {
4 
5     /* token settings */
6     string public name;             /* token name              */
7     string public symbol;           /* token symbol            */
8     uint8  public decimals;         /* number of digits after the decimal point      */
9     uint   public totalTokens;      /* total amount of tokens  */
10     uint   public finalyze;
11 
12     /* token management data */
13     address public ownerContract;   /* contract owner         */
14     address public owner;           /* owner                  */
15     
16     /* arrays */
17     mapping (address => uint256) public balance;                  /* array of balance              */
18     mapping (address => mapping (address => uint256)) allowed;    /* arrays of allowed transfers  */
19     
20     /* events */
21     event Burn(address indexed from, uint256 value);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24     
25     /* get the total amount of tokens */
26     function totalSupply() public constant returns (uint256 _totalSupply){
27         return totalTokens;
28     }
29     
30     /* get the amount of tokens from a particular user */
31     function balanceOf(address _owner) public constant returns (uint256 _balance){
32         return balance[_owner];
33     }
34     
35     /* transfer tokens */
36     function transfer(address _to, uint256 _value) public returns (bool success) {
37         address addrSender;
38         if (msg.sender == ownerContract){
39             /* the message was sent by the owner. it means a bounty program */
40             addrSender = ownerContract;
41         } else {
42             /* transfer between users*/
43             addrSender = msg.sender;
44         }
45         
46         /* tokens are not enough */
47         if (balance[addrSender] < _value){
48             revert();
49         }
50         
51         /* overflow */
52         if ((balance[_to] + _value) < balance[_to]){
53             revert();
54         }
55         balance[addrSender] -= _value;
56         balance[_to] += _value;
57         
58         Transfer(addrSender, _to, _value);  
59         return true;
60     }
61     
62     /* how many tokens were allowed to send */
63     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
64         return allowed[_owner][_spender];
65     }
66     
67     /* Send tokens from the recipient to the recipient */
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
69         var _allowance = allowed[_from][msg.sender];
70         
71         /* check of allowed value */
72         if (_allowance < _value){
73             revert();
74         }
75         
76         /* not enough tokens */
77         if (balance[_from] < _value){
78             revert();
79         }
80         balance[_to] += _value;
81         balance[_from] -= _value;
82         allowed[_from][msg.sender] = _allowance - _value;
83         Transfer(_from, _to, _value);
84         return true;
85     }
86     
87     /* allow to send tokens between recipients */
88     function approve(address _spender, uint256 _value) public returns (bool success){
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93     
94     /* constructor */
95     function metahashtoken() public {
96         name = 'BITCOMO';
97         symbol = 'BM';
98         decimals = 2;
99         owner = msg.sender;
100         totalTokens = 0; /* when creating a token we do not add them */
101         finalyze = 0;
102     }
103     
104     /* set contract owner */
105     function setContract(address _ownerContract) public {
106         if (msg.sender == owner){
107             ownerContract = _ownerContract;
108         }
109     }
110     
111     function setOptions(uint256 tokenCreate) public {
112         /* set the amount, give the tokens to the contract */
113         if ((msg.sender == ownerContract) && (finalyze == 0)){
114             totalTokens += tokenCreate;
115             balance[ownerContract] += tokenCreate;
116         } else {
117             revert();
118         }
119     }
120     
121     function burn(uint256 _value) public returns (bool success) {
122         if (balance[msg.sender] <= _value){
123             revert();
124         }
125 
126         balance[msg.sender] -= _value;
127         totalTokens -= _value;
128         Burn(msg.sender, _value);
129         return true;
130     }
131     
132     /* the contract is closed. Either because of the amount reached, or by the deadline. */
133     function finalyzeContract() public {
134         if (msg.sender != owner){
135             revert();
136         }
137         finalyze = 1;
138     }
139 }