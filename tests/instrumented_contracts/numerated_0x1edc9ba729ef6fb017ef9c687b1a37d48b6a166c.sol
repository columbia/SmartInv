1 pragma solidity >=0.5.16 <0.6.9;
2 pragma experimental ABIEncoderV2;
3 //YOUWILLNEVERWALKALONE
4 interface tokenRecipient {
5     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
6 }
7 
8 contract StarkChain {
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     uint256 public totalSupply;
13     address payable public fundsWallet;
14     uint256 public maximumTarget;
15     uint256 public lastBlock;
16     uint256 public rewardTimes;
17     uint256 public genesisReward;
18     uint256 public premined;
19     uint256 public nRewarMod;
20     uint256 public nWtime;
21 
22 
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27     event Burn(address indexed from, uint256 value);
28 
29     constructor(
30         uint256 initialSupply,
31         string memory tokenName,
32         string memory tokenSymbol
33     ) public {
34         initialSupply = 8923155  * 10 ** uint256(decimals);
35         tokenName = "Stark Chain";
36         tokenSymbol = "STARK";
37         lastBlock = 0;
38         nRewarMod = 5700;        
39         nWtime = 7776000;        
40         genesisReward = (10**uint256(decimals)); // Ödül Miktarı
41         maximumTarget = 100  * 10 ** uint256(decimals);
42         fundsWallet = msg.sender;
43         premined = 35850 * 10 ** uint256(decimals);
44         balanceOf[msg.sender] = premined;
45         balanceOf[address(this)] = initialSupply;
46         totalSupply =  initialSupply + premined;
47         name = tokenName;
48         symbol = tokenSymbol;
49     }
50 
51     function _transfer(address _from, address _to, uint _value) internal {
52         require(_to != address(0x0));
53         require(balanceOf[_from] >= _value);
54         require(balanceOf[_to] + _value >= balanceOf[_to]);
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         balanceOf[_from] -= _value;
57         balanceOf[_to] += _value;
58         emit Transfer(_from, _to, _value);
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     function transfer(address _to, uint256 _value) public returns (bool success) {
63         _transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68         require(_value <= allowance[_from][msg.sender]);     // Check allowance
69         allowance[_from][msg.sender] -= _value;
70         _transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function approve(address _spender, uint256 _value) public
75         returns (bool success) {
76         allowance[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
82         public
83         returns (bool success) {
84         tokenRecipient spender = tokenRecipient(_spender);
85         if (approve(_spender, _value)) {
86             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
87             return true;
88         }
89     }
90 
91     function burn(uint256 _value) public returns (bool success) {
92         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
93         balanceOf[msg.sender] -= _value;            // Subtract from the sender
94         totalSupply -= _value;                      // Updates totalSupply
95         emit Burn(msg.sender, _value);
96         return true;
97     }
98 
99     function burnFrom(address _from, uint256 _value) public returns (bool success) {
100         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
101         require(_value <= allowance[_from][msg.sender]);    // Check allowance
102         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
103         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
104         totalSupply -= _value;                              // Update totalSupply
105         emit Burn(_from, _value);
106         return true;
107     }
108 
109     function uintToString(uint256 v) internal pure returns(string memory str) {
110         uint maxlength = 100;
111         bytes memory reversed = new bytes(maxlength);
112         uint i = 0;
113         while (v != 0) {
114             uint remainder = v % 10;
115             v = v / 10;
116             reversed[i++] = byte(uint8(48 + remainder));
117         }
118         bytes memory s = new bytes(i + 1);
119         for (uint j = 0; j <= i; j++) {
120             s[j] = reversed[i - j];
121         }
122         str = string(s);
123     }
124 
125     function append(string memory a, string memory b) internal pure returns (string memory) {
126         return string(abi.encodePacked(a,"-",b));
127     }
128    
129 
130     function getCurrentBlockHash() public view returns (uint256) {
131             return uint256(blockhash(block.number-1));
132     }
133 
134     function getBlockHashAlgoritm(uint256 _blocknumber) public view returns(uint256, uint256){
135         uint256 crew = uint256(blockhash(_blocknumber)) % nRewarMod;
136         return (crew, block.number-1);
137     }
138 
139     function checkBlockReward() public view returns (uint256, uint256) {
140         uint256 crew = uint256(blockhash(block.number-1)) % nRewarMod;
141         return (crew, block.number-1);
142     }
143 
144     struct stakeInfo {
145       uint256 _stocktime;
146       uint256 _stockamount;
147     }
148 
149     address[] totalminers;
150 
151     mapping (address => stakeInfo) nStockDetails;
152 
153     struct rewarddetails {
154         uint256 _artyr;
155         bool _didGetReward;
156         bool _didisign;
157     }
158 
159     mapping (string => rewarddetails) nRewardDetails;
160 
161     struct nBlockDetails {
162         uint256 _bTime;
163         uint256 _tInvest;
164     }
165 
166     mapping (uint256 => nBlockDetails) bBlockIteration;
167 
168     struct activeMiners {
169         address bUser;
170     }
171 
172     mapping(uint256 => activeMiners[]) aMiners;
173 
174 
175     function totalMinerCount() view public returns (uint256) {
176         return totalminers.length;
177     }
178 
179 
180     function addressHashs() view public returns (uint256) {
181         return uint256(msg.sender) % 10000000000;
182     }    
183 
184 
185     function stakerStatus(address _addr) view public returns(bool){
186 
187         if(nStockDetails[_addr]._stocktime == 0)
188         {
189             return false;
190         }
191         else 
192         {
193             return true;
194         }
195     }
196 
197     function stakerAmount(address _addr) view public returns(uint256){
198 
199         if(nStockDetails[_addr]._stocktime == 0)
200         {
201             return 0;
202         } 
203         else 
204         {
205             return nStockDetails[_addr]._stockamount;
206         }
207     }
208 
209 
210     function stakerActiveTotal() view public returns(uint256) {
211         return aMiners[lastBlock].length; 
212     }
213    
214    
215     function generalCheckPoint()  private view returns(string memory) {
216        return append(uintToString(addressHashs()),uintToString(lastBlock));
217     }  
218     
219    
220     function necessarySignForReward(uint256 _bnumber) public returns (uint256)  { 
221        require(stakerStatus(msg.sender) == true);
222        require((block.number-1) - _bnumber  <= 100);        
223        require(nStockDetails[msg.sender]._stocktime + nWtime > now);   
224        require(uint256(blockhash(_bnumber)) % nRewarMod == 1);
225        
226        if(bBlockIteration[lastBlock]._bTime + 1800 < now)       
227        {
228            lastBlock += 1;
229            bBlockIteration[lastBlock]._bTime = now;
230        }
231        require(nRewardDetails[generalCheckPoint()]._artyr == 0);
232 
233        bBlockIteration[lastBlock]._tInvest += nStockDetails[msg.sender]._stockamount;
234        nRewardDetails[generalCheckPoint()]._artyr = now;
235        nRewardDetails[generalCheckPoint()]._didGetReward = false;
236        nRewardDetails[generalCheckPoint()]._didisign = true;
237        aMiners[lastBlock].push(activeMiners(msg.sender));
238        return 200;
239    }
240 
241    
242    function rewardGet(uint256 _bnumber) public returns(uint256) { 
243        require(stakerStatus(msg.sender) == true);
244        require((block.number-1) - _bnumber  > 100);        
245        require(uint256(blockhash(_bnumber)) % nRewarMod == 1);
246        require(nStockDetails[msg.sender]._stocktime + nWtime > now  ); 
247        require(nRewardDetails[generalCheckPoint()]._didGetReward == false);
248        require(nRewardDetails[generalCheckPoint()]._didisign == true);
249        
250        uint256 halving = lastBlock / 365;   
251        
252 
253        uint256 totalRA = 128 * genesisReward;
254        
255        if(halving==0)
256        {
257            totalRA = 128 * genesisReward;
258        }
259        else if(halving==1)
260        {
261            totalRA = 256 * genesisReward;
262        }
263        else if(halving==2)
264        {
265            totalRA = 512 * genesisReward;
266        }
267        else if(halving==3)
268        {
269            totalRA = 1024 * genesisReward;
270        }
271        else if(halving==4)
272        {
273            totalRA = 2048 * genesisReward;
274        }
275        else if(halving==5)
276        {
277            totalRA = 4096 * genesisReward;
278        }
279        else if(halving==6)
280        {
281            totalRA = 8192 * genesisReward;
282        }
283        else if(halving==7)
284        {
285            totalRA = 4096 * genesisReward;
286        }
287        else if(halving==8)
288        {
289            totalRA = 2048 * genesisReward;
290        }
291        else if(halving==9)
292        {
293            totalRA = 1024 * genesisReward;
294        }
295        else if(halving==10)
296        {
297            totalRA = 512 * genesisReward;
298        }
299        else if(halving==11)
300        {
301            totalRA = 256 * genesisReward;
302        }
303        else if(halving==12)
304        {
305            totalRA = 128 * genesisReward;
306        }
307        else if(halving==13)
308        {
309            totalRA = 64 * genesisReward;
310        }
311        else if(halving==14)
312        {
313            totalRA = 32 * genesisReward;
314        }
315        else if(halving==15)
316        {
317            totalRA = 16 * genesisReward;
318        }
319        else if(halving==16)
320        {
321            totalRA = 8 * genesisReward;
322        }
323        else if(halving==17)
324        {
325            totalRA = 4 * genesisReward;
326        }
327        else if(halving==18)
328        {
329            totalRA = 2 * genesisReward;
330        }
331        else if(halving==19)
332        {
333            totalRA = 1 * genesisReward;
334        }
335        else if(halving>19)
336        {
337            totalRA = 1 * genesisReward;
338        }
339 
340        uint256 usersReward = (totalRA * (nStockDetails[msg.sender]._stockamount * 100) / bBlockIteration[lastBlock]._tInvest) /  100;
341        nRewardDetails[generalCheckPoint()]._didGetReward = true;
342        _transfer(address(this), msg.sender, usersReward);
343        return usersReward;
344    }
345 
346    function startMining(uint256 mineamount) public returns (uint256) {
347 
348       uint256 realMineAmount = mineamount * 10 ** uint256(decimals);     
349       require(realMineAmount >= 10 * 10 ** uint256(decimals)); 
350       require(nStockDetails[msg.sender]._stocktime == 0);     
351       maximumTarget +=  realMineAmount;
352       nStockDetails[msg.sender]._stocktime = now;
353       nStockDetails[msg.sender]._stockamount = realMineAmount;
354       totalminers.push(msg.sender);
355       _transfer(msg.sender, address(this), realMineAmount);
356       return 200;
357    }
358 
359    function tokenPayBack() public returns(uint256) {
360        require(stakerStatus(msg.sender) == true);
361        require(nStockDetails[msg.sender]._stocktime + nWtime < now  );
362        nStockDetails[msg.sender]._stocktime = 0;
363        _transfer(address(this),msg.sender,nStockDetails[msg.sender]._stockamount);
364        return nStockDetails[msg.sender]._stockamount;
365    }
366 
367    struct memoInfo {
368        uint256 _receiveTime;
369        uint256 _receiveAmount;
370        address _senderAddr;
371        string _senderMemo;
372    }
373 
374   mapping(address => memoInfo[]) memoGetProcess;
375 
376   function sendMemoToken(uint256 _amount, address _to, string memory _memo)  public returns(uint256) {
377       memoGetProcess[_to].push(memoInfo(now, _amount, msg.sender, _memo));
378       _transfer(msg.sender, _to, _amount);
379       return 200;
380   }
381 
382   function sendMemoOnly(address _to, string memory _memo)  public returns(uint256) {
383       memoGetProcess[_to].push(memoInfo(now,0, msg.sender, _memo));
384       _transfer(msg.sender, _to, 0);
385       return 200;
386   }
387 
388 
389   function yourMemos(address _addr, uint256 _index) view public returns(uint256,
390    uint256,
391    string memory,
392    address) {
393 
394        uint256 rTime = memoGetProcess[_addr][_index]._receiveTime;
395        uint256 rAmount = memoGetProcess[_addr][_index]._receiveAmount;
396        string memory sMemo = memoGetProcess[_addr][_index]._senderMemo;
397        address sAddr = memoGetProcess[_addr][_index]._senderAddr;
398        if(memoGetProcess[_addr][_index]._receiveTime == 0){
399             return (0, 0,"0", _addr);
400        }else {
401             return (rTime, rAmount,sMemo, sAddr);
402        }
403   }
404 
405 
406    function yourMemosCount(address _addr) view public returns(uint256) {
407        return  memoGetProcess[_addr].length;
408    }
409 
410    function appendMemos(string memory a, string memory b,string memory c,string memory d) internal pure returns (string memory) {
411         return string(abi.encodePacked(a,"#",b,"#",c,"#",d));
412    }
413 
414    function addressToString(address _addr) public pure returns(string memory) {
415     bytes32 value = bytes32(uint256(_addr));
416     bytes memory alphabet = "0123456789abcdef";
417 
418     bytes memory str = new bytes(51);
419     str[0] = "0";
420     str[1] = "x";
421     for (uint i = 0; i < 20; i++) {
422         str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
423         str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
424     }
425     return string(str);
426 }
427 
428    function getYourMemosOnly(address _addr) view public returns(string[] memory) {
429        
430        uint total =  memoGetProcess[_addr].length;
431        string[] memory messages = new string[](total);
432       
433        for (uint i=0; i < total; i++) {
434              
435             messages[i] = appendMemos(uintToString(memoGetProcess[_addr][i]._receiveTime),memoGetProcess[_addr][i]._senderMemo,uintToString(memoGetProcess[_addr][i]._receiveAmount),addressToString(memoGetProcess[_addr][i]._senderAddr));
436        }
437 
438        return messages;
439    }
440 
441 }