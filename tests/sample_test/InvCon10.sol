1 pragma solidity ^0.4.24;


2 library SafeMath {
    
3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4         if (a == 0) {
5             return 0;
6         }
7         uint256 c = a * b;
8         assert(c / a == b);
9         return c;
10     }

11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a / b;
13     }

14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }

18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 }

24 contract ERC20Basic {
25     function totalSupply() public view returns (uint256);
26     function balanceOf(address who) public view returns (uint256);
27     function transfer(address to, uint256 value) public returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 }

30 contract ERC20 is ERC20Basic {
31     function allowance(address owner, address spender) public view returns (uint256);
32     function transferFrom(address from, address to, uint256 value) public returns (bool);
33     function approve(address spender, uint256 value) public returns (bool); 
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }

36 contract BasicToken is ERC20Basic {
37     using SafeMath for uint256;

38     mapping(address => uint256) balances;

39     uint256 totalSupply_;

40     function totalSupply() public view returns (uint256) {
41         return totalSupply_;
42     }

43     function transfer(address _to, uint256 _value) public returns (bool) {
44         require(_to != address(0));
45         require(_value <= balances[msg.sender]);

46         balances[msg.sender] = balances[msg.sender].sub(_value);
47         balances[_to] = balances[_to].add(_value);
    
48         emit Transfer(msg.sender, _to, _value);
49         return true;
50     }

51     function balanceOf(address _owner) public view returns (uint256) {
52         return balances[_owner];
53     }
54 }

55 contract Ownable {

56     address public owner;
57     address public operator;

58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);

60     constructor() public {
61         owner    = msg.sender;
62         operator = msg.sender;
63     }

64     modifier onlyOwner() { require(msg.sender == owner); _; }
65     modifier onlyOwnerOrOperator() { require(msg.sender == owner || msg.sender == operator); _; }

66     function transferOwnership(address _newOwner) external onlyOwner {
67         require(_newOwner != address(0));
68         emit OwnershipTransferred(owner, _newOwner);
69         owner = _newOwner;
70     }
  
71     function transferOperator(address _newOperator) external onlyOwner {
72         require(_newOperator != address(0));
73         emit OperatorTransferred(operator, _newOperator);
74         operator = _newOperator;
75     }
76 }

77 contract BlackList is Ownable {

78     event Lock(address indexed LockedAddress);
79     event Unlock(address indexed UnLockedAddress);

80     mapping( address => bool ) public blackList;

81     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }

82     function SetLockAddress(address _lockAddress) external onlyOwnerOrOperator returns (bool) {
83         require(_lockAddress != address(0));
84         require(_lockAddress != owner);
85         require(blackList[_lockAddress] != true);
        
86         blackList[_lockAddress] = true;
        
87         emit Lock(_lockAddress);

88         return true;
89     }

90     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
91         require(blackList[_unlockAddress] != false);
        
92         blackList[_unlockAddress] = false;
        
93         emit Unlock(_unlockAddress);

94         return true;
95     }
96 }

97 contract Pausable is Ownable {
98     event Pause();
99     event Unpause();

100     bool public paused = false;

101     modifier whenNotPaused() { require(!paused); _; }
102     modifier whenPaused() { require(paused); _; }

103     function pause() onlyOwnerOrOperator whenNotPaused public {
104         paused = true;
105         emit Pause();
106     }

107     function unpause() onlyOwner whenPaused public {
108         paused = false;
109         emit Unpause();
110     }
111 }

112 contract StandardToken is ERC20, BasicToken {
  
113     mapping (address => mapping (address => uint256)) internal allowed;

114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115         require(_to != address(0));
116         require(_value <= balances[_from]);
117         require(_value <= allowed[_from][msg.sender]);

118         balances[_from] = balances[_from].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    
121         emit Transfer(_from, _to, _value);
122         emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
    
123         return true;
124     }

125     function approve(address _spender, uint256 _value) public returns (bool) {
126         allowed[msg.sender][_spender] = _value;
    
127         emit Approval(msg.sender, _spender, _value);
    
128         return true;
129     }

130     function allowance(address _owner, address _spender) public view returns (uint256) {
131         return allowed[_owner][_spender];
132     }

133     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
134         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
    
135         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    
136         return true;
137     }

138     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
139         uint256 oldValue = allowed[msg.sender][_spender];
    
140         if (_subtractedValue > oldValue) {
141             allowed[msg.sender][_spender] = 0;
142         } else {
143             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
144         }
    
145         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146         return true;
147     }
148 }

149 contract MultiTransferToken is StandardToken, Ownable {

150     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
151         require(_to.length == _amount.length);

152         uint256 ui;
153         uint256 amountSum = 0;
    
154         for (ui = 0; ui < _to.length; ui++) {
155             require(_to[ui] != address(0));

156             amountSum = amountSum.add(_amount[ui]);
157         }

158         require(amountSum <= balances[msg.sender]);

159         for (ui = 0; ui < _to.length; ui++) {
160             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
161             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
        
162             emit Transfer(msg.sender, _to[ui], _amount[ui]);
163         }
    
164         return true;
165     }
166 }

167 contract BurnableToken is StandardToken, Ownable {

168     event BurnAdminAmount(address indexed burner, uint256 value);

169     function burnAdminAmount(uint256 _value) onlyOwner public {
170         require(_value <= balances[msg.sender]);

171         balances[msg.sender] = balances[msg.sender].sub(_value);
172         totalSupply_ = totalSupply_.sub(_value);
    
173         emit BurnAdminAmount(msg.sender, _value);
174         emit Transfer(msg.sender, address(0), _value);
175     }
176 }

177 contract MintableToken is StandardToken, Ownable {
178     event Mint(address indexed to, uint256 amount);
179     event MintFinished();

180     bool public mintingFinished = false;

181     modifier canMint() { require(!mintingFinished); _; }

182     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
183         totalSupply_ = totalSupply_.add(_amount);
184         balances[_to] = balances[_to].add(_amount);
    
185         emit Mint(_to, _amount);
186         emit Transfer(address(0), _to, _amount);
    
187         return true;
188     }

189     function finishMinting() onlyOwner canMint public returns (bool) {
190         mintingFinished = true;
191         emit MintFinished();
192         return true;
193     }
194 }

195 contract PausableToken is StandardToken, Pausable, BlackList {

196     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
197         return super.transfer(_to, _value);
198     }

199     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
200         require(blackList[_from] != true);
201         require(blackList[_to] != true);

202         return super.transferFrom(_from, _to, _value);
203     }

204     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
205         return super.approve(_spender, _value);
206     }

207     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
208         return super.increaseApproval(_spender, _addedValue);
209     }

210     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
211         return super.decreaseApproval(_spender, _subtractedValue);
212     }
213 }