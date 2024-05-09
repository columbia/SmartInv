1 pragma solidity ^0.4.19;
2 
3 contract ADM312 {
4 
5   address public COO;
6   address public CTO;
7   address public CFO;
8   address private coreAddress;
9   address public logicAddress;
10   address public superAddress;
11 
12   modifier onlyAdmin() {
13     require(msg.sender == COO || msg.sender == CTO || msg.sender == CFO);
14     _;
15   }
16   
17   modifier onlyContract() {
18     require(msg.sender == coreAddress || msg.sender == logicAddress || msg.sender == superAddress);
19     _;
20   }
21     
22   modifier onlyContractAdmin() {
23     require(msg.sender == coreAddress || msg.sender == logicAddress || msg.sender == superAddress || msg.sender == COO || msg.sender == CTO || msg.sender == CFO);
24      _;
25   }
26   
27   function transferAdmin(address _newAdminAddress1, address _newAdminAddress2) public onlyAdmin {
28     if(msg.sender == COO)
29     {
30         CTO = _newAdminAddress1;
31         CFO = _newAdminAddress2;
32     }
33     if(msg.sender == CTO)
34     {
35         COO = _newAdminAddress1;
36         CFO = _newAdminAddress2;
37     }
38     if(msg.sender == CFO)
39     {
40         COO = _newAdminAddress1;
41         CTO = _newAdminAddress2;
42     }
43   }
44   
45   function transferContract(address _newCoreAddress, address _newLogicAddress, address _newSuperAddress) external onlyAdmin {
46     coreAddress  = _newCoreAddress;
47     logicAddress = _newLogicAddress;
48     superAddress = _newSuperAddress;
49     SetCoreInterface(_newLogicAddress).setCoreContract(_newCoreAddress);
50     SetCoreInterface(_newSuperAddress).setCoreContract(_newCoreAddress);
51   }
52 
53 
54 }
55 
56 contract ERC721 {
57     
58   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
59   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
60 
61   function totalSupply() public view returns (uint256 total);
62   function balanceOf(address _owner) public view returns (uint256 balance);
63   function ownerOf(uint256 _tokenId) public view returns (address owner);
64   function transfer(address _to, uint256 _tokenId) public;
65   function approve(address _to, uint256 _tokenId) public;
66   function takeOwnership(uint256 _tokenId) public;
67   
68 }
69 
70 contract SetCoreInterface {
71    function setCoreContract(address _neWCoreAddress) external; 
72 }
73 
74 contract CaData is ADM312, ERC721 {
75     
76     function CaData() public {
77         COO = msg.sender;
78         CTO = msg.sender;
79         CFO = msg.sender;
80         createCustomAtom(0,0,4,0,0,0,0);
81     }
82     
83     function kill() external
84 	{
85 	    require(msg.sender == COO);
86 		selfdestruct(msg.sender);
87 	}
88     
89     function() public payable{}
90     
91     uint public randNonce  = 0;
92     
93     struct Atom 
94     {
95       uint64   dna;
96       uint8    gen;
97       uint8    lev;
98       uint8    cool;
99       uint32   sons;
100       uint64   fath;
101 	  uint64   moth;
102 	  uint128  isRent;
103 	  uint128  isBuy;
104 	  uint32   isReady;
105     }
106     
107     Atom[] public atoms;
108     
109     mapping (uint64  => bool) public dnaExist;
110     mapping (address => bool) public bonusReceived;
111     mapping (address => uint) public ownerAtomsCount;
112     mapping (uint => address) public atomOwner;
113     
114     event NewWithdraw(address sender, uint balance);
115 
116     
117     //ADMIN
118     
119     function createCustomAtom(uint64 _dna, uint8 _gen, uint8 _lev, uint8 _cool, uint128 _isRent, uint128 _isBuy, uint32 _isReady) public onlyAdmin {
120         require(dnaExist[_dna]==false && _cool+_lev>=4);
121         Atom memory newAtom = Atom(_dna, _gen, _lev, _cool, 0, 2**50, 2**50, _isRent, _isBuy, _isReady);
122         uint id = atoms.push(newAtom) - 1;
123         atomOwner[id] = msg.sender;
124         ownerAtomsCount[msg.sender]++;
125         dnaExist[_dna] = true;
126     }
127     
128     function withdrawBalance() public payable onlyAdmin {
129 		NewWithdraw(msg.sender, address(this).balance);
130         CFO.transfer(address(this).balance);
131     }
132     
133     //MAPPING_SETTERS
134     
135     function incRandNonce() external onlyContract {
136         randNonce++;
137     }
138     
139     function setDnaExist(uint64 _dna, bool _newDnaLocking) external onlyContractAdmin {
140         dnaExist[_dna] = _newDnaLocking;
141     }
142     
143     function setBonusReceived(address _add, bool _newBonusLocking) external onlyContractAdmin {
144         bonusReceived[_add] = _newBonusLocking;
145     }
146     
147     function setOwnerAtomsCount(address _owner, uint _newCount) external onlyContract {
148         ownerAtomsCount[_owner] = _newCount;
149     }
150     
151     function setAtomOwner(uint _atomId, address _owner) external onlyContract {
152         atomOwner[_atomId] = _owner;
153     }
154     
155     //ATOM_SETTERS
156     
157     function pushAtom(uint64 _dna, uint8 _gen, uint8 _lev, uint8 _cool, uint32 _sons, uint64 _fathId, uint64 _mothId, uint128 _isRent, uint128 _isBuy, uint32 _isReady) external onlyContract returns (uint id) {
158         Atom memory newAtom = Atom(_dna, _gen, _lev, _cool, _sons, _fathId, _mothId, _isRent, _isBuy, _isReady);
159         id = atoms.push(newAtom) -1;
160     }
161 	
162 	function setAtomDna(uint _atomId, uint64 _dna) external onlyAdmin {
163         atoms[_atomId].dna = _dna;
164     }
165 	
166 	function setAtomGen(uint _atomId, uint8 _gen) external onlyAdmin {
167         atoms[_atomId].gen = _gen;
168     }
169     
170     function setAtomLev(uint _atomId, uint8 _lev) external onlyContract {
171         atoms[_atomId].lev = _lev;
172     }
173     
174     function setAtomCool(uint _atomId, uint8 _cool) external onlyContract {
175         atoms[_atomId].cool = _cool;
176     }
177     
178     function setAtomSons(uint _atomId, uint32 _sons) external onlyContract {
179         atoms[_atomId].sons = _sons;
180     }
181     
182     function setAtomFath(uint _atomId, uint64 _fath) external onlyContract {
183         atoms[_atomId].fath = _fath;
184     }
185     
186     function setAtomMoth(uint _atomId, uint64 _moth) external onlyContract {
187         atoms[_atomId].moth = _moth;
188     }
189     
190     function setAtomIsRent(uint _atomId, uint128 _isRent) external onlyContract {
191         atoms[_atomId].isRent = _isRent;
192     }
193     
194     function setAtomIsBuy(uint _atomId, uint128 _isBuy) external onlyContract {
195         atoms[_atomId].isBuy = _isBuy;
196     }
197     
198     function setAtomIsReady(uint _atomId, uint32 _isReady) external onlyContractAdmin {
199         atoms[_atomId].isReady = _isReady;
200     }
201     
202     //ERC721
203     
204     mapping (uint => address) tokenApprovals;
205     
206     function totalSupply() public view returns (uint256 total){
207   	    return atoms.length;
208   	}
209   	
210   	function balanceOf(address _owner) public view returns (uint256 balance) {
211         return ownerAtomsCount[_owner];
212     }
213     
214     function ownerOf(uint256 _tokenId) public view returns (address owner) {
215         return atomOwner[_tokenId];
216     }
217       
218     function _transfer(address _from, address _to, uint256 _tokenId) private {
219         atoms[_tokenId].isBuy  = 0;
220         atoms[_tokenId].isRent = 0;
221         ownerAtomsCount[_to]++;
222         ownerAtomsCount[_from]--;
223         atomOwner[_tokenId] = _to;
224         Transfer(_from, _to, _tokenId);
225     }
226   
227     function transfer(address _to, uint256 _tokenId) public {
228         require(msg.sender == atomOwner[_tokenId]);
229         _transfer(msg.sender, _to, _tokenId);
230     }
231     
232     function approve(address _to, uint256 _tokenId) public {
233         require(msg.sender == atomOwner[_tokenId]);
234         tokenApprovals[_tokenId] = _to;
235         Approval(msg.sender, _to, _tokenId);
236     }
237     
238     function takeOwnership(uint256 _tokenId) public {
239         require(tokenApprovals[_tokenId] == msg.sender);
240         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
241     }
242     
243 }
244 
245 contract CaCoreInterface {
246     function createCombinedAtom(uint, uint) external returns (uint);
247     function createRandomAtom() external returns (uint);
248     function createTransferAtom(address , address , uint) external;
249 }
250 
251 contract CryptoAtomsLogicV2{
252     
253     address public CaDataAddress = 0x9b3554E6FC4F81531F6D43b611258bd1058ef6D5;
254     CaData public CaDataContract = CaData(CaDataAddress);
255     CaCoreInterface private CaCoreContract;
256     
257     bool public pauseMode = false;
258     bool public bonusMode = true;
259     
260     uint128   public newAtomFee = 1 finney;
261     uint8     public buyFeeRate = 0;
262     
263     uint8[4]  public levelupValues  = [0, 
264                                        2, 
265                                        5, 
266                                        10];
267 
268     event NewSetRent(address sender, uint atom);
269     event NewSetBuy(address sender, uint atom);
270     event NewUnsetRent(address sender, uint atom);
271     event NewUnsetBuy(address sender, uint atom);
272     event NewAutoRentAtom(address sender, uint atom);
273     event NewRentAtom(address sender, uint atom, address receiver, uint amount);
274     event NewBuyAtom(address sender, uint atom, address receiver, uint amount);
275     event NewEvolveAtom(address sender, uint atom);
276     event NewBonusAtom(address sender, uint atom);
277     
278     function() public payable{}
279     
280     function kill() external
281 	{
282 	    require(msg.sender == CaDataContract.CTO());
283 		selfdestruct(msg.sender); 
284 	}
285 	
286 	modifier onlyAdmin() {
287       require(msg.sender == CaDataContract.COO() || msg.sender == CaDataContract.CFO() || msg.sender == CaDataContract.CTO());
288       _;
289      }
290 	
291 	modifier onlyActive() {
292         require(pauseMode == false);
293         _;
294     }
295     
296     modifier onlyOwnerOf(uint _atomId, bool _flag) {
297         require((tx.origin == CaDataContract.atomOwner(_atomId)) == _flag);
298         _;
299     }
300     
301     modifier onlyRenting(uint _atomId, bool _flag) {
302         uint128 isRent;
303         (,,,,,,,isRent,,) = CaDataContract.atoms(_atomId);
304         require((isRent > 0) == _flag);
305         _;
306     }
307     
308     modifier onlyBuying(uint _atomId, bool _flag) {
309         uint128 isBuy;
310         (,,,,,,,,isBuy,) = CaDataContract.atoms(_atomId);
311         require((isBuy > 0) == _flag);
312         _;
313     }
314     
315     modifier onlyReady(uint _atomId) {
316         uint32 isReady;
317         (,,,,,,,,,isReady) = CaDataContract.atoms(_atomId);
318         require(isReady <= now);
319         _;
320     }
321     
322     modifier beDifferent(uint _atomId1, uint _atomId2) {
323         require(_atomId1 != _atomId2);
324         _;
325     }
326     
327     function setCoreContract(address _neWCoreAddress) external {
328         require(msg.sender == CaDataAddress);
329         CaCoreContract = CaCoreInterface(_neWCoreAddress);
330     }
331     
332     function setPauseMode(bool _newPauseMode) external onlyAdmin {
333         pauseMode = _newPauseMode;
334     }
335     
336     function setGiftMode(bool _newBonusMode) external onlyAdmin {
337         bonusMode = _newBonusMode;
338     }
339    
340     function setFee(uint128 _newFee) external onlyAdmin {
341         newAtomFee = _newFee;
342     }
343     
344     function setRate(uint8 _newRate) external onlyAdmin {
345         buyFeeRate = _newRate;
346     }
347     
348     function setLevelup(uint8[4] _newLevelup) external onlyAdmin {
349         levelupValues = _newLevelup;
350     }
351     
352     function setIsRentByAtom(uint _atomId, uint128 _fee) external onlyActive onlyOwnerOf(_atomId,true) onlyRenting(_atomId, false) onlyReady(_atomId) {
353 	    require(_fee > 0);
354 	    CaDataContract.setAtomIsRent(_atomId,_fee);
355 	    NewSetRent(tx.origin,_atomId);
356   	}
357   	
358   	function setIsBuyByAtom(uint _atomId, uint128 _fee) external onlyActive onlyOwnerOf(_atomId,true) onlyBuying(_atomId, false){
359 	    require(_fee > 0);
360 	    CaDataContract.setAtomIsBuy(_atomId,_fee);
361 	    NewSetBuy(tx.origin,_atomId);
362   	}
363   	
364   	function unsetIsRentByAtom(uint _atomId) external onlyActive onlyOwnerOf(_atomId, true) onlyRenting(_atomId, true){
365 	    CaDataContract.setAtomIsRent(_atomId,0);
366 	    NewUnsetRent(tx.origin,_atomId);
367   	}
368   	
369   	function unsetIsBuyByAtom(uint _atomId) external onlyActive onlyOwnerOf(_atomId, true) onlyBuying(_atomId, true){
370 	    CaDataContract.setAtomIsBuy(_atomId,0);
371 	    NewUnsetBuy(tx.origin,_atomId);
372   	}
373   	
374   	function autoRentByAtom(uint _atomId, uint _ownedId) external payable onlyActive beDifferent(_atomId, _ownedId) onlyOwnerOf(_atomId, true) onlyOwnerOf(_ownedId,true) onlyReady(_atomId) onlyReady(_ownedId)  {
375         require(newAtomFee == msg.value);
376         CaDataAddress.transfer(newAtomFee);
377         uint id = CaCoreContract.createCombinedAtom(_atomId,_ownedId);
378         NewAutoRentAtom(tx.origin,id);
379   	}
380   	
381   	 function rentByAtom(uint _atomId, uint _ownedId) external payable onlyActive beDifferent(_atomId, _ownedId) onlyOwnerOf(_ownedId, true) onlyRenting(_atomId, true) onlyReady(_ownedId) {
382 	    address owner = CaDataContract.atomOwner(_atomId);
383 	    uint128 isRent;
384         (,,,,,,,isRent,,) = CaDataContract.atoms(_atomId);
385 	    require(isRent + newAtomFee == msg.value);
386 	    owner.transfer(isRent);
387 	    CaDataAddress.transfer(newAtomFee);
388         uint id = CaCoreContract.createCombinedAtom(_atomId,_ownedId);
389         NewRentAtom(tx.origin,id,owner,isRent);
390   	}
391   	
392   	function buyByAtom(uint _atomId) external payable onlyActive onlyOwnerOf(_atomId, false) onlyBuying(_atomId, true) {
393   	    address owner = CaDataContract.atomOwner(_atomId);
394   	    uint128 isBuy;
395         (,,,,,,,,isBuy,) = CaDataContract.atoms(_atomId);
396 	    require(isBuy == msg.value);
397 	    if(buyFeeRate>0)
398 	    {
399 	        uint128 fee = uint128(isBuy/100) * buyFeeRate;
400             isBuy = isBuy - fee;
401 	        CaDataAddress.transfer(fee);
402 	    }
403 	    owner.transfer(isBuy);
404         CaDataContract.setAtomIsBuy(_atomId,0);
405         CaDataContract.setAtomIsRent(_atomId,0);
406         CaDataContract.setOwnerAtomsCount(tx.origin,CaDataContract.ownerAtomsCount(tx.origin)+1);
407         CaDataContract.setOwnerAtomsCount(owner,CaDataContract.ownerAtomsCount(owner)-1);
408         CaDataContract.setAtomOwner(_atomId,tx.origin);
409         CaCoreContract.createTransferAtom(owner, tx.origin, _atomId);
410         NewBuyAtom(tx.origin,_atomId,owner,isBuy);
411   	}
412   	
413   	function evolveByAtom(uint _atomId) external onlyActive onlyOwnerOf(_atomId, true) {
414   	    uint8 lev;
415   	    uint8 cool;
416   	    uint32 sons;
417   	    (,,lev,cool,sons,,,,,) = CaDataContract.atoms(_atomId);
418   	    require(lev < 4 && sons >= levelupValues[lev]);
419   	    CaDataContract.setAtomLev(_atomId,lev+1);
420   	    CaDataContract.setAtomCool(_atomId,cool-1);
421         NewEvolveAtom(tx.origin,_atomId);
422   	}
423   	
424   	function receiveBonus() onlyActive external {
425   	    require(bonusMode == true && CaDataContract.bonusReceived(tx.origin) == false);
426   	    CaDataContract.setBonusReceived(tx.origin,true);
427         uint id = CaCoreContract.createRandomAtom();
428         NewBonusAtom(tx.origin,id);
429     }
430     
431 }