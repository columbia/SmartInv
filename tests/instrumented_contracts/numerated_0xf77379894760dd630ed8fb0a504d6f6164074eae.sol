1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-13
3 */
4 pragma solidity ^0.4.25;
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;       
19     }       
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 contract Ownable {
31     address public owner;
32     address public newOwner;
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34     constructor() public {
35         owner = msg.sender;
36         newOwner = address(0);
37     }
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42     modifier onlyNewOwner() {
43         require(msg.sender != address(0));
44         require(msg.sender == newOwner);
45         _;
46     }
47     function transferOwnership(address _newOwner) public onlyOwner {
48         require(_newOwner != address(0));
49         newOwner = _newOwner;
50     }
51     function acceptOwnership() public onlyNewOwner returns(bool) {
52         emit OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54     }
55 }
56 contract Pausable is Ownable {
57   event Pause();
58   event Unpause();
59   bool public paused = false;
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64   modifier whenPaused() {
65     require(paused);
66     _;
67   }
68   function pause() onlyOwner whenNotPaused public {
69     paused = true;
70     emit Pause();
71   }
72   function unpause() onlyOwner whenPaused public {
73     paused = false;
74     emit Unpause();
75   }
76 }
77 contract ERC20 {
78     function totalSupply() public view returns (uint256);
79     function balanceOf(address who) public view returns (uint256);
80     function allowance(address owner, address spender) public view returns (uint256);
81     function transfer(address to, uint256 value) public returns (bool);
82     function transferFrom(address from, address to, uint256 value) public returns (bool);
83     function approve(address spender, uint256 value) public returns (bool);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 interface TokenRecipient {
88     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
89 }
90 contract KSLToken is ERC20, Ownable, Pausable {
91     using SafeMath for uint256;
92     struct LockupInfo {
93         uint256 releaseTime;
94         uint256 termOfRound;
95         uint256 unlockAmountPerRound;        
96         uint256 lockupBalance;
97     }
98     string public name;
99     string public symbol;
100     uint8 public decimals;
101     uint256 internal initialSupply;
102     uint256 internal totalSupply_;
103     mapping(address => uint256) internal balances;
104     mapping(address => bool) internal locks;
105     mapping(address => bool) public frozen;
106     mapping(address => mapping(address => uint256)) internal allowed;
107     mapping(address => LockupInfo) internal lockupInfo;
108     event Unlock(address indexed holder, uint256 value);
109     event Lock(address indexed holder, uint256 value);
110     event Burn(address indexed owner, uint256 value);
111     event Mint(uint256 value);
112     event Freeze(address indexed holder);
113     event Unfreeze(address indexed holder);
114     modifier notFrozen(address _holder) {
115         require(!frozen[_holder]);
116         _;
117     }
118     constructor() public {
119         name = "KSL Token";
120         symbol = "KSL";
121         decimals = 18;
122         initialSupply = 10000000000;
123         totalSupply_ = initialSupply * 10 ** uint(decimals);
124         balances[owner] = totalSupply_;
125         emit Transfer(address(0), owner, totalSupply_);
126     }
127     function () public payable {
128         revert();
129     }
130     function totalSupply() public view returns (uint256) {
131         return totalSupply_;
132     }
133     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
134         if (locks[msg.sender]) {
135             autoUnlock(msg.sender);            
136         }
137         require(_to != address(0));
138         require(_value <= balances[msg.sender]);
139         // SafeMath.sub will throw if there is not enough balance.
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         emit Transfer(msg.sender, _to, _value);
143         return true;
144     }
145     function balanceOf(address _holder) public view returns (uint balance) {
146         return balances[_holder];
147     }
148     function lockupBalance(address _holder) public view returns (uint256 balance) {
149         return lockupInfo[_holder].lockupBalance;
150     }    
151     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
152         if (locks[_from]) {
153             autoUnlock(_from);            
154         }
155         require(_to != address(0));
156         require(_value <= balances[_from]);
157         require(_value <= allowed[_from][msg.sender]);
158         balances[_from] = balances[_from].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161         emit Transfer(_from, _to, _value);
162         return true;
163     }
164     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
165         allowed[msg.sender][_spender] = _value;
166         emit Approval(msg.sender, _spender, _value);
167         return true;
168     }
169     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
170         require(isContract(_spender));
171         TokenRecipient spender = TokenRecipient(_spender);
172         if (approve(_spender, _value)) {
173             spender.receiveApproval(msg.sender, _value, this, _extraData);
174             return true;
175         }
176     }
177     function allowance(address _holder, address _spender) public view returns (uint256) {
178         return allowed[_holder][_spender];
179     }
180     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
181         require(locks[_holder] == false);
182         require(_releaseStart > now);
183         require(_termOfRound > 0);
184         require(_amount.mul(_releaseRate).div(100) > 0);
185         require(balances[_holder] >= _amount);
186         balances[_holder] = balances[_holder].sub(_amount);
187         lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.mul(_releaseRate).div(100), _amount);
188         locks[_holder] = true;
189         emit Lock(_holder, _amount);
190         return true;
191     }
192     function unlock(address _holder) public onlyOwner returns (bool) {
193         require(locks[_holder] == true);
194         uint256 releaseAmount = lockupInfo[_holder].lockupBalance;
195         delete lockupInfo[_holder];
196         locks[_holder] = false;
197         emit Unlock(_holder, releaseAmount);
198         balances[_holder] = balances[_holder].add(releaseAmount);
199         return true;
200     }
201     function freezeAccount(address _holder) public onlyOwner returns (bool) {
202         require(!frozen[_holder]);
203         frozen[_holder] = true;
204         emit Freeze(_holder);
205         return true;
206     }
207     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
208         require(frozen[_holder]);
209         frozen[_holder] = false;
210         emit Unfreeze(_holder);
211         return true;
212     }
213     function getNowTime() public view returns(uint256) {
214       return now;
215     }
216     function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {
217         return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);
218     }
219     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
220         require(_to != address(0));
221         require(_value <= balances[owner]);
222         balances[owner] = balances[owner].sub(_value);
223         balances[_to] = balances[_to].add(_value);
224         emit Transfer(owner, _to, _value);
225         return true;
226     }
227     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
228         distribute(_to, _value);
229         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
230         return true;
231     }
232     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
233         token.transfer(_to, _value);
234         return true;
235     }
236     function burn(uint256 _value) public onlyOwner returns (bool success) {
237         require(_value <= balances[msg.sender]);
238         address burner = msg.sender;
239         balances[burner] = balances[burner].sub(_value);
240         totalSupply_ = totalSupply_.sub(_value);
241         emit Burn(burner, _value);
242         return true;
243     }
244     function mint( uint256 _amount) onlyOwner public returns (bool) {
245         totalSupply_ = totalSupply_.add(_amount);
246         balances[owner] = balances[owner].add(_amount);
247         emit Transfer(address(0), owner, _amount);
248         return true;
249     }
250     function isContract(address addr) internal view returns (bool) {
251         uint size;
252         assembly{size := extcodesize(addr)}
253         return size > 0;
254     }
255     function autoUnlock(address _holder) internal returns (bool) {
256         if (lockupInfo[_holder].releaseTime <= now) {
257             return releaseTimeLock(_holder);
258         }
259         return false;
260     }
261     function releaseTimeLock(address _holder) internal returns(bool) {
262         require(locks[_holder]);
263         uint256 releaseAmount = 0;
264         // If lock status of holder is finished, delete lockup info. 
265         for( ; lockupInfo[_holder].releaseTime <= now ; )
266         {
267             if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {   
268                 releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);
269                 delete lockupInfo[_holder];
270                 locks[_holder] = false;
271                 break;             
272             } else {
273                 releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);
274                 lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);
275                 lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);
276             }            
277         }
278         emit Unlock(_holder, releaseAmount);
279         balances[_holder] = balances[_holder].add(releaseAmount);
280         return true;
281     }
282 }