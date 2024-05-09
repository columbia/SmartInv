1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract TokenERC20 {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     
22     // This generates a public event on the blockchain that will notify clients
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 
25     // This notifies clients about the amount burnt
26     event Burn(address indexed from, uint256 value);
27 
28     mapping(address => uint256[]) public keySearch;
29     mapping(address => bool) public keyExists;
30     mapping(bytes32 => bool) private pExists;
31     mapping(bytes32 => uint256) private pSearch;
32 
33     address public contractOwner;
34 
35     string[]    public annotation;
36     string[]    public externalUid;
37     address[]   public fromAddress;
38     address[]   public toAddress;
39     uint256[]   public numberOfTokens;
40     string[]    public action;
41     
42     
43     
44 
45     /**
46      * Constructor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     constructor(
51         uint256 initialSupply,
52         string memory tokenName,
53         string memory tokenSymbol,
54         address contractOwnerC,
55         address defaultReturnAddress
56     ) public {
57         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
58         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
59         name = tokenName;                                   // Set the name for display purposes
60         symbol = tokenSymbol;                               // Set the symbol for display purposes
61         contractOwner = contractOwnerC;
62         string[]    memory tmpAnnotation;
63         string[]    memory tmpExternalUid;
64         address[]   memory tmpFromAddress;
65         address[]   memory tmpToAddress;
66         uint256[]   memory tmpNumberOfTokens;
67         string[]    memory tmpAction;
68         annotation = tmpAnnotation;
69         externalUid = tmpExternalUid;
70         action = tmpAction;
71         fromAddress = tmpFromAddress;
72         toAddress = tmpToAddress;
73         numberOfTokens = tmpNumberOfTokens;
74         //addCBA(contractOwner, false, "no match, default value" , false, "no match, default value");
75         cBAList.push(cashBackAddressObj({cba:defaultReturnAddress, cbaActive:false, bankUid:"no match, default value" , bankUIDActive:false, expired:true}));
76         cBAStatusMessage[contractOwner].push("default value, not intended for use");
77     }
78 
79     /**
80      * Internal transfer, only can be called by this contract
81      */
82     function _transfer(address _from, address _to, uint _value) internal {
83         // Prevent transfer to 0x0 address. Use burn() instead
84         require(_to != address(0x0));
85         // Check if the sender has enough
86         require(balanceOf[_from] >= _value);
87         // Check for overflows
88         require(balanceOf[_to] + _value >= balanceOf[_to]);
89         // Save this for an assertion in the future
90         uint previousBalances = balanceOf[_from] + balanceOf[_to];
91         // Subtract from the sender
92         balanceOf[_from] -= _value;
93         // Add the same to the recipient
94         balanceOf[_to] += _value;
95         emit Transfer(_from, _to, _value);
96         // Asserts are used to use static analysis to find bugs in your code. They should never fail
97         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
98     }
99 
100     /**
101      * Transfer tokens
102      *
103      * Send `_value` tokens to `_to` from your account
104      *
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transfer(address _to, uint256 _value) public returns (bool success) {
109         _transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     /**
114      * Transfer tokens from other address
115      *
116      * Send `_value` tokens to `_to` on behalf of `_from`
117      *
118      * @param _from The address of the sender
119      * @param _to The address of the recipient
120      * @param _value the amount to send
121      */
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
123         require(_value <= allowance[_from][msg.sender]);     // Check allowance
124         allowance[_from][msg.sender] -= _value;
125         _transfer(_from, _to, _value);
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address
131      *
132      * Allows `_spender` to spend no more than `_value` tokens on your behalf
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      */
137     function approve(address _spender, uint256 _value) public
138         returns (bool success) {
139         allowance[msg.sender][_spender] = _value;
140         emit Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /**
145      * Set allowance for other address and notify
146      *
147      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      * @param _extraData some extra information to send to the approved contract
152      */
153     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
154         public
155         returns (bool success) {
156         tokenRecipient spender = tokenRecipient(_spender);
157         if (approve(_spender, _value)) {
158             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
159             return true;
160         }
161     }
162 
163     /**
164      * Destroy tokens
165      *
166      * Remove `_value` tokens from the system irreversibly
167      *
168      * @param _value the amount of money to burn
169      */
170     function burn(uint256 _value) public returns (bool success) {
171         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
172         balanceOf[msg.sender] -= _value;            // Subtract from the sender
173         totalSupply -= _value;                      // Updates totalSupply
174         emit Burn(msg.sender, _value);
175         return true;
176     }
177 
178     /**
179      * Destroy tokens from other account
180      *
181      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
182      *
183      * @param _from the address of the sender
184      * @param _value the amount of money to burn
185      */
186     function burnFrom(address _from, uint256 _value) public returns (bool success) {
187         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
188         require(_value <= allowance[_from][msg.sender]);    // Check allowance
189         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
190         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
191         totalSupply -= _value;                              // Update totalSupply
192         emit Burn(_from, _value);
193         return true;
194     }
195     
196     
197     function collapseInput(string memory _in) private pure returns (bytes32){
198         return keccak256(abi.encode (_in));
199     }    
200     
201     function testPExists(string memory _in) public view returns (bool){
202         return pExists[collapseInput(_in)];
203     }
204     
205     function getPSearch(string memory _in) public view returns (uint256){
206         return pSearch[collapseInput(_in)];
207     }
208     
209     
210     /**
211      * Annotated functions
212      * keyIndex usually == to toAddress
213      */
214     function addAnnotation(
215             string memory tmpAnnotation,
216             string memory tmpExternalUid,
217             address tmpFromAddress,
218             address tmpToAddress,
219             uint256 tmpNumberOfTokens,
220             address keyIndex,
221             string memory tmpAction
222         ) private {
223         require(msg.sender == contractOwner);
224         bytes32 tmpPKey = collapseInput(tmpExternalUid);
225         require(!pExists[tmpPKey]); 
226         uint256 id = annotation.length;
227         pExists[tmpPKey] = true;
228         pSearch[tmpPKey] = id;
229         if (!keyExists[keyIndex]) {
230             keyExists[keyIndex] = true;
231             uint256[] memory tmpArr;
232             keySearch[keyIndex]= tmpArr;
233         }
234         keySearch[keyIndex].push(id);
235         annotation.push(tmpAnnotation);
236         externalUid.push(tmpExternalUid);
237         fromAddress.push(tmpFromAddress);
238         toAddress.push(tmpToAddress);
239         action.push(tmpAction);
240         numberOfTokens.push(tmpNumberOfTokens);
241         
242     }
243     
244     function getNumberOfAnnotations(address keyIndex) public view returns(uint256){
245         uint256 num = 0;
246         if(keyExists[keyIndex]){
247             num = keySearch[keyIndex].length;
248         }
249         return num;
250     }
251     
252     function annotatedTransfer(address to, uint tokens, string memory uid, string memory note) public{
253         require(msg.sender == contractOwner);
254         transfer(to, tokens);
255         addAnnotation(note, uid, msg.sender, to, tokens, to, "send");
256     }
257     
258     function annotatedBurn(address to, uint tokens, string memory uid, string memory note) public{
259         require(msg.sender == contractOwner);
260         burn(tokens);
261         addAnnotation(note, uid, msg.sender, to, tokens, to, "burn");
262     }
263     
264     function returnNote(uint256 trx) public view returns(
265         string memory,
266         string memory,
267         address,
268         address,
269         uint256,
270         string memory
271         ){
272         return(
273             annotation[trx],
274             externalUid[trx],
275             fromAddress[trx],
276             toAddress[trx],
277             numberOfTokens[trx],
278             action[trx]
279             );
280         }
281 
282     function annotationLength()public view returns(uint256){
283         return annotation.length;
284     }
285 
286     address public cashBackManager;
287     mapping(address => uint256) public getCBAbyAddress;
288     mapping(bytes32 => uint256) public getCBAbyBkUid;
289     cashBackAddressObj[] public cBAList;
290     mapping(address => string[]) public cBATransactionMessage;
291     mapping(address => string[]) public cBAStatusMessage;
292     mapping(address => uint256[]) public expiredAddress;
293     mapping(bytes32 => uint256[]) public expiredBankUid;
294 
295     struct cashBackAddressObj{
296         address cba;
297         bool cbaActive;
298         string bankUid;
299         bool bankUIDActive;
300         bool expired;
301     }
302     
303     modifier restricted(){
304         require(msg.sender == cashBackManager || msg.sender == contractOwner);
305         _;
306     }
307     
308     function setCashbackManager(address cba) public restricted{
309         cashBackManager=cba;
310     }
311 
312     function cBAListLength()public view returns(uint256){
313         return cBAList.length;
314     }
315     
316     function addCBA(address cba, bool cbaStatus, string memory bkUid, bool bkUidStatus, string memory statusMsg) public restricted{
317         uint256 oldIdx=getCBAbyAddress[cba];
318         if(oldIdx>0){
319             expiredAddress[cba].push(oldIdx);
320             cBAList[oldIdx].expired=true;
321             cBAStatusMessage[cba].push("Expired Address");
322         }
323         bytes32 bkUidHash = collapseInput(bkUid);
324         uint256 oldBkUidIndex = getCBAbyBkUid[bkUidHash];
325         if(oldBkUidIndex > 0){
326             expiredBankUid[bkUidHash].push(oldBkUidIndex);
327             cBAList[oldBkUidIndex].expired=true;
328             cBAStatusMessage[cba].push("Expired Bank UID");
329         }
330         getCBAbyAddress[cba]=cBAList.length;
331         getCBAbyBkUid[bkUidHash]=cBAList.length;
332         cBAList.push(cashBackAddressObj({cba:cba,cbaActive:cbaStatus,bankUid:bkUid,bankUIDActive:bkUidStatus, expired:false}));
333         cBAStatusMessage[cba].push(statusMsg);
334     }
335     
336     function getExpiredBkUidIndexes(string memory bkUid)public view returns (uint256[] memory){
337         return expiredBankUid[collapseInput(bkUid)];
338     }
339 
340     function getExpiredAddressIndexes(address cba)public view returns (uint256[] memory){
341             return expiredAddress[cba];
342     }
343 
344     function searchByBkUid(string memory bkUid) public view returns(uint256){
345         return getCBAbyBkUid[collapseInput(bkUid)];
346     }
347     
348     function getCBAStatusMessageLength(address cba) public view returns(uint256){
349         return cBAStatusMessage[cba].length;
350     }
351     
352     function getCBATransactionMessageLength(address cba) public view returns(uint256){
353         return  cBATransactionMessage[cba].length;
354     }
355     
356     function getCashBackObject(uint256 obj_id)public  view returns(address, bool, string memory, bool, bool){
357         return(
358                 cBAList[obj_id].cba,
359                 cBAList[obj_id].cbaActive,
360                 cBAList[obj_id].bankUid,
361                 cBAList[obj_id].bankUIDActive,
362                 cBAList[obj_id].expired
363             );
364     }
365     
366 
367     function annotatedCashBack(uint256 tk, address _to, string memory transferMsg) public{
368         uint256 sndIdx = getCBAbyAddress[msg.sender];
369         require(sndIdx>0 && cBAList[sndIdx].bankUIDActive);
370         cBATransactionMessage[cBAList[sndIdx].cba].push(transferMsg);
371         transfer(_to,tk);
372     }
373 }