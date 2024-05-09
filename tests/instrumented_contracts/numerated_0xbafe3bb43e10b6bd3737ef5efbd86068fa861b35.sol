1 /* version metahashtoken 0.1.4 RC */
2 pragma solidity ^0.5.1;
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
25 
26 
27     /* get the total amount of tokens */
28     function totalSupply() public view returns (uint256 _totalSupply){
29         return totalTokens;
30     }
31     
32     /* get the amount of tokens from a particular user */
33     function balanceOf(address _owner) public view returns (uint256 _balance){
34         return balance[_owner];
35     }
36     
37     /* transfer tokens */
38     function transfer(address _to, uint256 _value) public returns (bool success) {
39         /* tokens are not enough */
40         if (balance[msg.sender] < _value){
41             revert();
42         }
43         
44         /* overflow */
45         if ((balance[_to] + _value) < balance[_to]){
46             revert();
47         }
48         balance[msg.sender] -= _value;
49         balance[_to] += _value;
50         
51         emit Transfer(msg.sender, _to, _value);  
52         return true;
53     }
54     
55     /* how many tokens were allowed to send */
56     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
57         return allowed[_owner][_spender];
58     }
59     
60     /* Send tokens from the recipient to the recipient */
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
62         uint256 nAllowance;
63         nAllowance = allowed[_from][msg.sender];
64         
65         /* check of allowed value */
66         if (nAllowance < _value){
67             revert();
68         }
69         
70         /* not enough tokens */
71         if (balance[_from] < _value){
72             revert();
73         }
74 
75         /* overflow */
76         if ((balance[_to] + _value) < balance[_to]){
77             revert();
78         }
79         
80         balance[_to] += _value;
81         balance[_from] -= _value;
82         allowed[_from][msg.sender] = nAllowance - _value;
83         emit Transfer(_from, _to, _value);
84         return true;
85     }
86     
87     /* allow to send tokens between recipients */
88     function approve(address _spender, uint256 _value) public returns (bool success){
89         /* overflow */
90         if ((balance[_spender] + _value) < balance[_spender]){
91             revert();
92         }
93 
94         allowed[msg.sender][_spender] = _value;
95         emit Approval(msg.sender, _spender, _value);
96         return true;
97     }
98     
99     /* constructor */
100     constructor() public {
101         name = 'MetaHash';
102         symbol = 'MH';
103         decimals = 2;
104         owner = msg.sender;
105         totalTokens = 0; /* when creating a token we do not add them */
106         finalyze = 0;
107     }
108     
109     /* set contract owner */
110     function setContract(address _ownerContract) public {
111         if (msg.sender == owner){
112             ownerContract = _ownerContract;
113         }
114     }
115     
116     function setOptions(uint256 tokenCreate) public {
117         /* set the amount, give the tokens to the contract */
118         if ((msg.sender == ownerContract) && (finalyze == 0)){
119             totalTokens += tokenCreate;
120             balance[ownerContract] += tokenCreate;
121         } else {
122             revert();
123         }
124     }
125     
126     function burn(uint256 _value) public returns (bool success) {
127         if (balance[msg.sender] <= _value){
128             revert();
129         }
130 
131         balance[msg.sender] -= _value;
132         totalTokens -= _value;
133         emit Burn(msg.sender, _value);
134         return true;
135     }
136     
137     /* the contract is closed. Either because of the amount reached, or by the deadline. */
138     function finalyzeContract() public {
139         if (msg.sender != owner){
140             revert();
141         }
142         finalyze = 1;
143     }
144 }