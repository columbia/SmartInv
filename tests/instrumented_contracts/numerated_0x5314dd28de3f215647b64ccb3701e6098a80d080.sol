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
116     function createCustomAtom(uint64 _dna, uint8 _gen, uint8 _lev, uint8 _cool, uint128 _isRent, uint128 _isBuy, uint32 _isReady) public onlyAdmin {
117         require(dnaExist[_dna]==false && _cool+_lev>=4);
118         Atom memory newAtom = Atom(_dna, _gen, _lev, _cool, 0, 2**50, 2**50, _isRent, _isBuy, _isReady);
119         uint id = atoms.push(newAtom) - 1;
120         atomOwner[id] = msg.sender;
121         ownerAtomsCount[msg.sender]++;
122         dnaExist[_dna] = true;
123     }
124     
125     function withdrawBalance() public payable onlyAdmin {
126 		NewWithdraw(msg.sender, address(this).balance);
127         CFO.transfer(address(this).balance);
128     }
129         
130     function incRandNonce() external onlyContract {
131         randNonce++;
132     }
133     
134     function setDnaExist(uint64 _dna, bool _newDnaLocking) external onlyContractAdmin {
135         dnaExist[_dna] = _newDnaLocking;
136     }
137     
138     function setBonusReceived(address _add, bool _newBonusLocking) external onlyContractAdmin {
139         bonusReceived[_add] = _newBonusLocking;
140     }
141     
142     function setOwnerAtomsCount(address _owner, uint _newCount) external onlyContract {
143         ownerAtomsCount[_owner] = _newCount;
144     }
145     
146     function setAtomOwner(uint _atomId, address _owner) external onlyContract {
147         atomOwner[_atomId] = _owner;
148     }
149         
150     function pushAtom(uint64 _dna, uint8 _gen, uint8 _lev, uint8 _cool, uint32 _sons, uint64 _fathId, uint64 _mothId, uint128 _isRent, uint128 _isBuy, uint32 _isReady) external onlyContract returns (uint id) {
151         Atom memory newAtom = Atom(_dna, _gen, _lev, _cool, _sons, _fathId, _mothId, _isRent, _isBuy, _isReady);
152         id = atoms.push(newAtom) -1;
153     }
154 	
155 	function setAtomDna(uint _atomId, uint64 _dna) external onlyAdmin {
156         atoms[_atomId].dna = _dna;
157     }
158 	
159 	function setAtomGen(uint _atomId, uint8 _gen) external onlyAdmin {
160         atoms[_atomId].gen = _gen;
161     }
162     
163     function setAtomLev(uint _atomId, uint8 _lev) external onlyContract {
164         atoms[_atomId].lev = _lev;
165     }
166     
167     function setAtomCool(uint _atomId, uint8 _cool) external onlyContract {
168         atoms[_atomId].cool = _cool;
169     }
170     
171     function setAtomSons(uint _atomId, uint32 _sons) external onlyContract {
172         atoms[_atomId].sons = _sons;
173     }
174     
175     function setAtomFath(uint _atomId, uint64 _fath) external onlyContract {
176         atoms[_atomId].fath = _fath;
177     }
178     
179     function setAtomMoth(uint _atomId, uint64 _moth) external onlyContract {
180         atoms[_atomId].moth = _moth;
181     }
182     
183     function setAtomIsRent(uint _atomId, uint128 _isRent) external onlyContract {
184         atoms[_atomId].isRent = _isRent;
185     }
186     
187     function setAtomIsBuy(uint _atomId, uint128 _isBuy) external onlyContract {
188         atoms[_atomId].isBuy = _isBuy;
189     }
190     
191     function setAtomIsReady(uint _atomId, uint32 _isReady) external onlyContractAdmin {
192         atoms[_atomId].isReady = _isReady;
193     }
194     
195     //ERC721
196     
197     mapping (uint => address) tokenApprovals;
198     
199     function totalSupply() public view returns (uint256 total){
200   	    return atoms.length;
201   	}
202   	
203   	function balanceOf(address _owner) public view returns (uint256 balance) {
204         return ownerAtomsCount[_owner];
205     }
206     
207     function ownerOf(uint256 _tokenId) public view returns (address owner) {
208         return atomOwner[_tokenId];
209     }
210       
211     function _transfer(address _from, address _to, uint256 _tokenId) private {
212         atoms[_tokenId].isBuy  = 0;
213         atoms[_tokenId].isRent = 0;
214         ownerAtomsCount[_to]++;
215         ownerAtomsCount[_from]--;
216         atomOwner[_tokenId] = _to;
217         Transfer(_from, _to, _tokenId);
218     }
219   
220     function transfer(address _to, uint256 _tokenId) public {
221         require(msg.sender == atomOwner[_tokenId]);
222         _transfer(msg.sender, _to, _tokenId);
223     }
224     
225     function approve(address _to, uint256 _tokenId) public {
226         require(msg.sender == atomOwner[_tokenId]);
227         tokenApprovals[_tokenId] = _to;
228         Approval(msg.sender, _to, _tokenId);
229     }
230     
231     function takeOwnership(uint256 _tokenId) public {
232         require(tokenApprovals[_tokenId] == msg.sender);
233         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
234     }
235     
236 }
237 
238 contract CaCoreInterface {
239     function createCombinedAtom(uint, uint) external returns (uint);
240     function createRandomAtom() external returns (uint);
241 }
242 
243 contract CryptoAtomsLogic{
244     
245     address public CaDataAddress = 0x9b3554E6FC4F81531F6D43b611258bd1058ef6D5;
246     CaData public CaDataContract = CaData(CaDataAddress);
247     CaCoreInterface private CaCoreContract;
248     
249     bool public pauseMode = false;
250     bool public bonusMode  = true;
251     
252     uint128   public newAtomFee = 1 finney;
253     
254     uint8[4]  public levelupValues  = [0, 
255                                        2, 
256                                        6, 
257                                        12];
258 
259     event NewSetRent(address sender, uint atom);
260     event NewSetBuy(address sender, uint atom);
261     event NewUnsetRent(address sender, uint atom);
262     event NewUnsetBuy(address sender, uint atom);
263     event NewAutoRentAtom(address sender, uint atom);
264     event NewRentAtom(address sender, uint atom, address receiver, uint amount);
265     event NewBuyAtom(address sender, uint atom, address receiver, uint amount);
266     event NewEvolveAtom(address sender, uint atom);
267     event NewBonusAtom(address sender, uint atom);
268     
269     function() public payable{}
270     
271     function kill() external
272 	{
273 	    require(msg.sender == CaDataContract.CTO());
274 		selfdestruct(msg.sender); 
275 	}
276 	
277 	modifier onlyAdmin() {
278       require(msg.sender == CaDataContract.COO() || msg.sender == CaDataContract.CFO() || msg.sender == CaDataContract.CTO());
279       _;
280      }
281 	
282 	modifier onlyActive() {
283         require(pauseMode == false);
284         _;
285     }
286     
287     modifier onlyOwnerOf(uint _atomId, bool _flag) {
288         require((msg.sender == CaDataContract.atomOwner(_atomId)) == _flag);
289         _;
290     }
291     
292     modifier onlyRenting(uint _atomId, bool _flag) {
293         uint128 isRent;
294         (,,,,,,,isRent,,) = CaDataContract.atoms(_atomId);
295         require((isRent > 0) == _flag);
296         _;
297     }
298     
299     modifier onlyBuying(uint _atomId, bool _flag) {
300         uint128 isBuy;
301         (,,,,,,,,isBuy,) = CaDataContract.atoms(_atomId);
302         require((isBuy > 0) == _flag);
303         _;
304     }
305     
306     modifier onlyReady(uint _atomId) {
307         uint32 isReady;
308         (,,,,,,,,,isReady) = CaDataContract.atoms(_atomId);
309         require(isReady <= now);
310         _;
311     }
312     
313     modifier beDifferent(uint _atomId1, uint _atomId2) {
314         require(_atomId1 != _atomId2);
315         _;
316     }
317     
318     function setCoreContract(address _neWCoreAddress) external {
319         require(msg.sender == CaDataAddress);
320         CaCoreContract = CaCoreInterface(_neWCoreAddress);
321     }
322     
323     function setPauseMode(bool _newPauseMode) external onlyAdmin {
324         pauseMode = _newPauseMode;
325     }
326     
327     function setGiftMode(bool _newBonusMode) external onlyAdmin {
328         bonusMode = _newBonusMode;
329     }
330     
331     function setFee(uint128 _newFee) external onlyAdmin {
332         newAtomFee = _newFee;
333     }
334     
335     function setLevelup(uint8[4] _newLevelup) external onlyAdmin {
336         levelupValues = _newLevelup;
337     }
338     
339     function setIsRentByAtom(uint _atomId, uint128 _fee) external onlyActive onlyOwnerOf(_atomId,true) onlyRenting(_atomId, false) onlyReady(_atomId) {
340 	    require(_fee > 0);
341 	    CaDataContract.setAtomIsRent(_atomId,_fee);
342 	    NewSetRent(msg.sender,_atomId);
343   	}
344   	
345   	function setIsBuyByAtom(uint _atomId, uint128 _fee) external onlyActive onlyOwnerOf(_atomId,true) onlyBuying(_atomId, false){
346 	    require(_fee > 0);
347 	    CaDataContract.setAtomIsBuy(_atomId,_fee);
348 	    NewSetBuy(msg.sender,_atomId);
349   	}
350   	
351   	function unsetIsRentByAtom(uint _atomId) external onlyActive onlyOwnerOf(_atomId, true) onlyRenting(_atomId, true){
352 	    CaDataContract.setAtomIsRent(_atomId,0);
353 	    NewUnsetRent(msg.sender,_atomId);
354   	}
355   	
356   	function unsetIsBuyByAtom(uint _atomId) external onlyActive onlyOwnerOf(_atomId, true) onlyBuying(_atomId, true){
357 	    CaDataContract.setAtomIsBuy(_atomId,0);
358 	    NewUnsetBuy(msg.sender,_atomId);
359   	}
360   	
361   	function autoRentByAtom(uint _atomId, uint _ownedId) external payable onlyActive beDifferent(_atomId, _ownedId) onlyOwnerOf(_atomId, true) onlyOwnerOf(_ownedId,true) onlyReady(_atomId) onlyReady(_ownedId)  {
362         require(newAtomFee == msg.value);
363         CaDataAddress.transfer(newAtomFee);
364         uint id = CaCoreContract.createCombinedAtom(_atomId,_ownedId);
365         NewAutoRentAtom(msg.sender,id);
366   	}
367   	
368   	 function rentByAtom(uint _atomId, uint _ownedId) external payable onlyActive beDifferent(_atomId, _ownedId) onlyOwnerOf(_ownedId, true) onlyRenting(_atomId, true) onlyReady(_ownedId) {
369 	    address owner = CaDataContract.atomOwner(_atomId);
370 	    uint128 isRent;
371         (,,,,,,,isRent,,) = CaDataContract.atoms(_atomId);
372 	    require(isRent + newAtomFee == msg.value);
373 	    owner.transfer(isRent);
374 	    CaDataAddress.transfer(newAtomFee);
375         uint id = CaCoreContract.createCombinedAtom(_atomId,_ownedId);
376         NewRentAtom(msg.sender,id,owner,isRent);
377   	}
378   	
379   	function buyByAtom(uint _atomId) external payable onlyActive onlyOwnerOf(_atomId, false) onlyBuying(_atomId, true) {
380   	    address owner = CaDataContract.atomOwner(_atomId);
381   	    uint128 isBuy;
382         (,,,,,,,,isBuy,) = CaDataContract.atoms(_atomId);
383 	    require(isBuy == msg.value);
384 	    owner.transfer(isBuy);
385         CaDataContract.setAtomIsBuy(_atomId,0);
386         CaDataContract.setAtomIsRent(_atomId,0);
387         CaDataContract.setOwnerAtomsCount(msg.sender,CaDataContract.ownerAtomsCount(msg.sender)+1);
388         CaDataContract.setOwnerAtomsCount(owner,CaDataContract.ownerAtomsCount(owner)-1);
389         CaDataContract.setAtomOwner(_atomId,msg.sender);
390         NewBuyAtom(msg.sender,_atomId,owner,isBuy);
391   	}
392   	
393   	function evolveByAtom(uint _atomId) external onlyActive onlyOwnerOf(_atomId, true) {
394   	    uint8 lev;
395   	    uint8 cool;
396   	    uint32 sons;
397   	    (,,lev,cool,sons,,,,,) = CaDataContract.atoms(_atomId);
398   	    require(lev < 4 && sons >= levelupValues[lev]);
399   	    CaDataContract.setAtomLev(_atomId,lev+1);
400   	    CaDataContract.setAtomCool(_atomId,cool-1);
401         NewEvolveAtom(msg.sender,_atomId);
402   	}
403   	
404   	function receiveBonus() onlyActive external {
405   	    require(bonusMode == true && CaDataContract.bonusReceived(msg.sender) == false);
406   	    CaDataContract.setBonusReceived(msg.sender,true);
407         uint id = CaCoreContract.createRandomAtom();
408         NewBonusAtom(msg.sender,id);
409     }
410     
411 }