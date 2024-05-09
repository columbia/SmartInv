1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 contract Ownable {
27     address public owner;
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29    constructor() public {
30       owner = msg.sender;
31     }
32     modifier onlyOwner() {
33       require(msg.sender == owner);
34       _;
35     }
36     function transferOwnership(address newOwner) public onlyOwner {
37       require(newOwner != address(0));
38       emit OwnershipTransferred(owner, newOwner);
39       owner = newOwner;
40     }
41 }
42 contract ERC20Basic {
43     function totalSupply() public view returns (uint256);
44     function balanceOf(address who) public view returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 contract ERC20 is ERC20Basic {
49     function allowance(address owner, address spender) public view returns (uint256);
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51     function approve(address spender, uint256 value) public returns (bool);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 contract BasicToken is ERC20Basic {
55     using SafeMath for uint256;
56     mapping(address => uint256) balances;
57     uint256 totalSupply_;
58     
59     function totalSupply() public view returns (uint256) {
60         return totalSupply_;
61     }
62     function transfer(address _to, uint256 _value) public returns (bool) {
63         require(_to != address(0));
64         require(_value <= balances[msg.sender]);
65         
66         balances[msg.sender] = balances[msg.sender].sub(_value);
67         balances[_to] = balances[_to].add(_value);
68         emit Transfer(msg.sender, _to, _value);
69         return true;
70     }
71     function balanceOf(address _owner) public view returns (uint256) {
72         return balances[_owner];
73     }
74 }
75 contract SEACTokens is ERC20, BasicToken {
76     mapping (address => mapping (address => uint256)) internal allowed;
77     
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79         require(_to != address(0));
80         require(_value <= balances[_from]);
81         require(_value <= allowed[_from][msg.sender]);
82     
83         balances[_from] = balances[_from].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86         
87         emit Transfer(_from, _to, _value);
88         return true;
89     }
90     function approve(address _spender, uint256 _value) public returns (bool) {
91         allowed[msg.sender][_spender] = _value;
92         emit Approval(msg.sender, _spender, _value);
93         return true;
94     }
95     function allowance(address _owner, address _spender) public view returns (uint256) {
96         return allowed[_owner][_spender];
97     }
98     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
100         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101         return true;
102     }
103     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
104         uint oldValue = allowed[msg.sender][_spender];
105         if (_subtractedValue > oldValue) {
106             allowed[msg.sender][_spender] = 0;
107         } else {
108             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
109         }
110         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111         return true;
112     }
113 }
114 contract Configurable {
115     uint256 public constant cap = 50000000*10**18;
116     uint256 public constant basePrice = 100*10**18;
117     uint256 public tokensSold = 0;
118     
119     uint256 public constant tokenReserve = 50000000*10**18;
120     uint256 public remainingTokens = 0;
121 }
122 contract CrowdsaleToken is SEACTokens, Configurable, Ownable {
123      enum Stages {
124         none,
125         icoStart, 
126         icoEnd
127     }
128     
129     Stages currentStage;
130     constructor() public {
131         currentStage = Stages.none;
132         balances[owner] = balances[owner].add(tokenReserve);
133         totalSupply_ = totalSupply_.add(tokenReserve);
134         remainingTokens = cap;
135         emit Transfer(address(this), owner, tokenReserve);
136     }
137     function () public payable {
138         require(currentStage == Stages.icoStart);
139         require(msg.value > 0);
140         require(remainingTokens > 0);
141         
142         
143         uint256 weiAmount = msg.value;
144         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
145         uint256 returnWei = 0;
146         
147         if(tokensSold.add(tokens) > cap){
148             uint256 newTokens = cap.sub(tokensSold);
149             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
150             returnWei = weiAmount.sub(newWei);
151             weiAmount = newWei;
152             tokens = newTokens;
153         }
154         
155         tokensSold = tokensSold.add(tokens);
156         remainingTokens = cap.sub(tokensSold);
157         if(returnWei > 0){
158             msg.sender.transfer(returnWei);
159             emit Transfer(address(this), msg.sender, returnWei);
160         }
161         
162         balances[msg.sender] = balances[msg.sender].add(tokens);
163         emit Transfer(address(this), msg.sender, tokens);
164         totalSupply_ = totalSupply_.add(tokens);
165         owner.transfer(weiAmount);
166     }
167     function startIco() public onlyOwner {
168         require(currentStage != Stages.icoEnd);
169         currentStage = Stages.icoStart;
170     }
171     function endIco() internal {
172         currentStage = Stages.icoEnd;
173         if(remainingTokens > 0)
174             balances[owner] = balances[owner].add(remainingTokens);
175         owner.transfer(address(this).balance); 
176     }
177     function finalizeIco() public onlyOwner {
178         require(currentStage != Stages.icoEnd);
179         endIco();
180     }
181 }
182 contract SEACASH is CrowdsaleToken {
183     string public constant name = "Southeast Asian Cash Tokens";
184     string public constant symbol = "SEACASH";
185     uint32 public constant decimals = 18;
186 }