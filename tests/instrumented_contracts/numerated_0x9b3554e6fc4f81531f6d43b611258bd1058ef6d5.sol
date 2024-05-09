1 contract ADM312 {
2 
3   address public COO;
4   address public CTO;
5   address public CFO;
6   address private coreAddress;
7   address public logicAddress;
8   address public superAddress;
9 
10   modifier onlyAdmin() {
11     require(msg.sender == COO || msg.sender == CTO || msg.sender == CFO);
12     _;
13   }
14   
15   modifier onlyContract() {
16     require(msg.sender == coreAddress || msg.sender == logicAddress || msg.sender == superAddress);
17     _;
18   }
19     
20   modifier onlyContractAdmin() {
21     require(msg.sender == coreAddress || msg.sender == logicAddress || msg.sender == superAddress || msg.sender == COO || msg.sender == CTO || msg.sender == CFO);
22      _;
23   }
24   
25   function transferAdmin(address _newAdminAddress1, address _newAdminAddress2) public onlyAdmin {
26     if(msg.sender == COO)
27     {
28         CTO = _newAdminAddress1;
29         CFO = _newAdminAddress2;
30     }
31     if(msg.sender == CTO)
32     {
33         COO = _newAdminAddress1;
34         CFO = _newAdminAddress2;
35     }
36     if(msg.sender == CFO)
37     {
38         COO = _newAdminAddress1;
39         CTO = _newAdminAddress2;
40     }
41   }
42   
43   function transferContract(address _newCoreAddress, address _newLogicAddress, address _newSuperAddress) external onlyAdmin {
44     coreAddress  = _newCoreAddress;
45     logicAddress = _newLogicAddress;
46     superAddress = _newSuperAddress;
47     SetCoreInterface(_newLogicAddress).setCoreContract(_newCoreAddress);
48     SetCoreInterface(_newSuperAddress).setCoreContract(_newCoreAddress);
49   }
50 
51 
52 }
53 
54 contract ERC721 {
55     
56   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
57   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
58 
59   function totalSupply() public view returns (uint256 total);
60   function balanceOf(address _owner) public view returns (uint256 balance);
61   function ownerOf(uint256 _tokenId) public view returns (address owner);
62   function transfer(address _to, uint256 _tokenId) public;
63   function approve(address _to, uint256 _tokenId) public;
64   function takeOwnership(uint256 _tokenId) public;
65   
66 }
67 
68 contract SetCoreInterface {
69    function setCoreContract(address _neWCoreAddress) external; 
70 }
71 
72 contract CryptoAtoms is ADM312, ERC721 {
73     
74     function CryptoAtoms () public {
75         COO = msg.sender;
76         CTO = msg.sender;
77         CFO = msg.sender;
78         createCustomAtom(0,0,4,0,0,0,0);
79     }
80     
81     function kill() external
82 	{
83 	    require(msg.sender == COO);
84 		selfdestruct(msg.sender);
85 	}
86     
87     function() public payable{}
88     
89     uint public randNonce  = 0;
90     
91     struct Atom 
92     {
93       uint64   dna;
94       uint8    gen;
95       uint8    lev;
96       uint8    cool;
97       uint32   sons;
98       uint64   fath;
99 	  uint64   moth;
100 	  uint128  isRent;
101 	  uint128  isBuy;
102 	  uint32   isReady;
103     }
104     
105     Atom[] public atoms;
106     
107     mapping (uint64  => bool) public dnaExist;
108     mapping (address => bool) public bonusReceived;
109     mapping (address => uint) public ownerAtomsCount;
110     mapping (uint => address) public atomOwner;
111     
112     event NewWithdraw(address sender, uint balance);
113     
114     function createCustomAtom(uint64 _dna, uint8 _gen, uint8 _lev, uint8 _cool, uint128 _isRent, uint128 _isBuy, uint32 _isReady) public onlyAdmin {
115         require(dnaExist[_dna]==false && _cool+_lev>=4);
116         Atom memory newAtom = Atom(_dna, _gen, _lev, _cool, 0, 2**50, 2**50, _isRent, _isBuy, _isReady);
117         uint id = atoms.push(newAtom) - 1;
118         atomOwner[id] = msg.sender;
119         ownerAtomsCount[msg.sender]++;
120         dnaExist[_dna] = true;
121     }
122     
123     function withdrawBalance() public payable onlyAdmin {
124 		NewWithdraw(msg.sender, address(this).balance);
125         CFO.transfer(address(this).balance);
126     }
127         
128     function incRandNonce() external onlyContract {
129         randNonce++;
130     }
131     
132     function setDnaExist(uint64 _dna, bool _newDnaLocking) external onlyContractAdmin {
133         dnaExist[_dna] = _newDnaLocking;
134     }
135     
136     function setBonusReceived(address _add, bool _newBonusLocking) external onlyContractAdmin {
137         bonusReceived[_add] = _newBonusLocking;
138     }
139     
140     function setOwnerAtomsCount(address _owner, uint _newCount) external onlyContract {
141         ownerAtomsCount[_owner] = _newCount;
142     }
143     
144     function setAtomOwner(uint _atomId, address _owner) external onlyContract {
145         atomOwner[_atomId] = _owner;
146     }
147         
148     function pushAtom(uint64 _dna, uint8 _gen, uint8 _lev, uint8 _cool, uint32 _sons, uint64 _fathId, uint64 _mothId, uint128 _isRent, uint128 _isBuy, uint32 _isReady) external onlyContract returns (uint id) {
149         Atom memory newAtom = Atom(_dna, _gen, _lev, _cool, _sons, _fathId, _mothId, _isRent, _isBuy, _isReady);
150         id = atoms.push(newAtom) -1;
151     }
152 	
153 	function setAtomDna(uint _atomId, uint64 _dna) external onlyAdmin {
154         atoms[_atomId].dna = _dna;
155     }
156 	
157 	function setAtomGen(uint _atomId, uint8 _gen) external onlyAdmin {
158         atoms[_atomId].gen = _gen;
159     }
160     
161     function setAtomLev(uint _atomId, uint8 _lev) external onlyContract {
162         atoms[_atomId].lev = _lev;
163     }
164     
165     function setAtomCool(uint _atomId, uint8 _cool) external onlyContract {
166         atoms[_atomId].cool = _cool;
167     }
168     
169     function setAtomSons(uint _atomId, uint32 _sons) external onlyContract {
170         atoms[_atomId].sons = _sons;
171     }
172     
173     function setAtomFath(uint _atomId, uint64 _fath) external onlyContract {
174         atoms[_atomId].fath = _fath;
175     }
176     
177     function setAtomMoth(uint _atomId, uint64 _moth) external onlyContract {
178         atoms[_atomId].moth = _moth;
179     }
180     
181     function setAtomIsRent(uint _atomId, uint128 _isRent) external onlyContract {
182         atoms[_atomId].isRent = _isRent;
183     }
184     
185     function setAtomIsBuy(uint _atomId, uint128 _isBuy) external onlyContract {
186         atoms[_atomId].isBuy = _isBuy;
187     }
188     
189     function setAtomIsReady(uint _atomId, uint32 _isReady) external onlyContractAdmin {
190         atoms[_atomId].isReady = _isReady;
191     }
192     
193     //ERC721
194     
195     mapping (uint => address) tokenApprovals;
196     
197     function totalSupply() public view returns (uint256 total){
198   	    return atoms.length;
199   	}
200   	
201   	function balanceOf(address _owner) public view returns (uint256 balance) {
202         return ownerAtomsCount[_owner];
203     }
204     
205     function ownerOf(uint256 _tokenId) public view returns (address owner) {
206         return atomOwner[_tokenId];
207     }
208       
209     function _transfer(address _from, address _to, uint256 _tokenId) private {
210         atoms[_tokenId].isBuy  = 0;
211         atoms[_tokenId].isRent = 0;
212         ownerAtomsCount[_to]++;
213         ownerAtomsCount[_from]--;
214         atomOwner[_tokenId] = _to;
215         Transfer(_from, _to, _tokenId);
216     }
217   
218     function transfer(address _to, uint256 _tokenId) public {
219         require(msg.sender == atomOwner[_tokenId]);
220         _transfer(msg.sender, _to, _tokenId);
221     }
222     
223     function approve(address _to, uint256 _tokenId) public {
224         require(msg.sender == atomOwner[_tokenId]);
225         tokenApprovals[_tokenId] = _to;
226         Approval(msg.sender, _to, _tokenId);
227     }
228     
229     function takeOwnership(uint256 _tokenId) public {
230         require(tokenApprovals[_tokenId] == msg.sender);
231         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
232     }
233     
234 }