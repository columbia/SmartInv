1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   address public admin;
11   uint256 public lockedIn;
12   uint256 public OWNER_AMOUNT;
13   uint256 public OWNER_PERCENT = 2;
14   uint256 public OWNER_MIN = 0.0001 ether;
15   
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor(address addr, uint256 percent, uint256 min) public {
28     require(addr != address(0), 'invalid addr');
29     owner = msg.sender;
30     admin = addr;
31     OWNER_PERCENT = percent;
32     OWNER_MIN = min;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender==owner || msg.sender==admin);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    * @notice Renouncing to ownership will leave the contract without an owner.
46    * It will not be possible to call the functions with the `onlyOwner`
47    * modifier anymore.
48    */
49   function renounceOwnership() public onlyOwner {
50     emit OwnershipRenounced(owner);
51     owner = address(0);
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address _newOwner) public onlyOwner {
59     _transferOwnership(_newOwner);
60   }
61 
62   /**
63    * @dev Transfers control of the contract to a newOwner.
64    * @param _newOwner The address to transfer ownership to.
65    */
66   function _transferOwnership(address _newOwner) internal {
67     require(_newOwner != address(0));
68     emit OwnershipTransferred(owner, _newOwner);
69     owner = _newOwner;
70   }
71 
72   function _cash() public view returns(uint256){
73       return address(this).balance;
74   }
75 
76   function kill() onlyOwner public{
77     require(lockedIn == 0, "invalid lockedIn");
78     selfdestruct(owner);
79   }
80   
81   function setAdmin(address addr) onlyOwner public{
82       require(addr != address(0), 'invalid addr');
83       admin = addr;
84   }
85   
86   function setOwnerPercent(uint256 percent) onlyOwner public{
87       OWNER_PERCENT = percent;
88   }
89   
90   function setOwnerMin(uint256 min) onlyOwner public{
91       OWNER_MIN = min;
92   }
93   
94   function _fee() internal returns(uint256){
95       uint256 fe = msg.value*OWNER_PERCENT/100;
96       if(fe < OWNER_MIN){
97           fe = OWNER_MIN;
98       }
99       OWNER_AMOUNT += fe;
100       return fe;
101   }
102   
103   function cashOut() onlyOwner public{
104     require(OWNER_AMOUNT > 0, 'invalid OWNER_AMOUNT');
105     owner.send(OWNER_AMOUNT);
106   }
107 
108   modifier isHuman() {
109       address _addr = msg.sender;
110       uint256 _codeLength;
111       assembly {_codeLength := extcodesize(_addr)}
112       require(_codeLength == 0, "sorry humans only");
113       _;
114   }
115 
116   modifier isContract() {
117       address _addr = msg.sender;
118       uint256 _codeLength;
119       assembly {_codeLength := extcodesize(_addr)}
120       require(_codeLength > 0, "sorry contract only");
121       _;
122   }
123 }
124 
125  /**
126  * luck100.win - Fair Ethereum game platform
127  * 
128  * Single dice
129  * 
130  * Winning rules:
131  * 
132  * result = sha3(txhash + blockhash(betBN+3)) % 6 + 1
133  * 
134  * 1.The player chooses a bet of 1-6 and bets up to 5 digits at the same time;
135  * 
136  * 2.After the player bets successfully, get the transaction hash txhash;
137  * 
138  * 3.Take the block that the player bets to count the new 3rd Ethereum block hash blockhash;
139  * 
140  * 4.Txhash and blockhash are subjected to sha3 encryption operation, and then modulo with 6 to 
141  * get the result of the lottery.
142  */
143 
144 
145 contract Dice1Contract is Ownable{
146     event betEvent(address indexed addr, uint256 betBlockNumber, uint256 betMask, uint256 amount);
147     event openEvent(address indexed addr, uint256 openBlockNumber, uint256 openNumber, bytes32 txhash, bool isWin);
148     struct Bet{
149         uint256 betBlockNumber;
150         uint256 openBlockNumber;
151         uint256 betMask;
152         uint256 openNumber;
153         uint256 amount;
154         uint256 winAmount;
155         bytes32 txhash;
156         bytes32 openHash;
157         bool isWin;
158     }
159     mapping(address=>mapping(uint256=>Bet)) betList;
160     uint256 constant MIN_BET = 0.01 ether;
161     uint8 public N = 3;
162     uint8 constant M = 6;
163     uint16[M] public MASKS = [0, 32, 48, 56, 60, 62];
164     uint16[M] public AMOUNTS = [0, 101, 253, 510, 1031, 2660];
165     uint16[M] public ODDS = [0, 600, 300, 200, 150, 120];
166     
167     constructor(address addr, uint256 percent, uint256 min) Ownable(addr, percent, min) public{
168         
169     }
170     
171     function() public payable{
172         uint8 diceNum = uint8(msg.data.length);
173         uint256 betMask = 0;
174         uint256 t = 0;
175         for(uint8 i=0;i<diceNum;i++){
176             t = uint256(msg.data[i]);
177             if(t==0 || t>M){
178                 diceNum--;
179                 continue;
180             }
181             betMask += 2**(t-1);
182         }
183         if(diceNum==0) return ;
184         _placeBet(betMask, diceNum);
185     }
186     
187     function placeBet(uint256 betMask, uint8 diceNum) public payable{
188         _placeBet(betMask, diceNum);
189     }
190     
191     function _placeBet(uint256 betMask, uint8 diceNum) private{
192         require(diceNum>0 && diceNum<M, 'invalid diceNum');
193         uint256 MAX_BET = AMOUNTS[diceNum]/100*(10**18);
194         require(msg.value>=MIN_BET && msg.value<=MAX_BET, 'invalid amount');
195         require(betMask>0 && betMask<=MASKS[diceNum], 'invalid betMask');
196         uint256 fee = _fee();
197         uint256 winAmount = (msg.value-fee)*ODDS[diceNum]/100;
198         lockedIn += winAmount;
199         betList[msg.sender][block.number] = Bet({
200             betBlockNumber:block.number,
201             openBlockNumber:block.number+N,
202             betMask:betMask,
203             openNumber:0,
204             amount:msg.value,
205             winAmount:winAmount,
206             txhash:0,
207             openHash:0,
208             isWin:false
209         });
210         emit betEvent(msg.sender, block.number, betMask, msg.value);
211     }
212     
213     function setN(uint8 n) onlyOwner public{
214         N = n;
215     }
216     
217     function open(address addr, uint256 bn, bytes32 txhash) onlyOwner public{
218         uint256 openBlockNumber = betList[addr][bn].openBlockNumber;
219         bytes32 openBlockHash = blockhash(openBlockNumber);
220         require(uint256(openBlockHash)>0, 'invalid openBlockNumber');
221         _open(addr, bn, txhash, openBlockHash);
222     }
223     
224     function open2(address addr, uint256 bn, bytes32 txhash, bytes32 openBlockHash) onlyOwner public{
225         _open(addr, bn, txhash, openBlockHash);
226     }
227     
228     function _open(address addr, uint256 bn, bytes32 txhash, bytes32 openBlockHash) private{
229         Bet storage bet = betList[addr][bn];
230         require(bet.betBlockNumber==bn && bet.openNumber==0, 'invalid bet');
231         lockedIn -= bet.winAmount;
232         bytes32 openHash = keccak256(abi.encodePacked(txhash, openBlockHash));
233         uint256 r = uint256(openHash) % M;
234         uint256 t = bet.betMask & (2**r);
235         bet.openNumber = r+1;
236         bet.txhash = txhash;
237         bet.openHash = openHash;
238         if(t > 0){
239             bet.isWin = true;
240             addr.send(bet.winAmount);
241         }
242         emit openEvent(addr, bet.openBlockNumber, bet.openNumber, txhash, bet.isWin);
243     }
244     
245     function getBet(address addr, uint256 bn) view public returns(uint256,uint256,uint256,uint256,uint256,uint256,bytes32,bytes32,bool){
246         Bet memory bet = betList[addr][bn];
247         return (bet.betBlockNumber, bet.openBlockNumber, bet.betMask, bet.openNumber, bet.amount, bet.winAmount, bet.txhash, bet.openHash, bet.isWin);
248     }
249     
250     function output() view public returns(uint8,uint256,uint256,uint16[M],uint16[M],uint16[M]){
251         return (N, OWNER_PERCENT, OWNER_MIN, MASKS, AMOUNTS, ODDS);
252     }
253 }