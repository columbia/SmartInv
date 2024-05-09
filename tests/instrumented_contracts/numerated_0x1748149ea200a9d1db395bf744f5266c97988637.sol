1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 
75 contract BNDESRegistry is Ownable() {
76 
77     /**
78         The account of clients and suppliers are assigned to states. 
79         Reserved accounts (e.g. from BNDES and ANCINE) do not have state.
80         AVAILABLE - The account is not yet assigned any role (any of them - client, supplier or any reserved addresses).
81         WAITING_VALIDATION - The account was linked to a legal entity but it still needs to be validated
82         VALIDATED - The account was validated
83         INVALIDATED_BY_VALIDATOR - The account was invalidated
84         INVALIDATED_BY_CHANGE - The client or supplier changed the ethereum account so the original one must be invalidated.
85      */
86     enum BlockchainAccountState {AVAILABLE,WAITING_VALIDATION,VALIDATED,INVALIDATED_BY_VALIDATOR,INVALIDATED_BY_CHANGE} 
87     BlockchainAccountState blockchainState; //Not used. Defined to create the enum type.
88 
89     address responsibleForSettlement;
90     address responsibleForRegistryValidation;
91     address responsibleForDisbursement;
92     address redemptionAddress;
93     address tokenAddress;
94 
95     /**
96         Describes the Legal Entity - clients or suppliers
97      */
98     struct LegalEntityInfo {
99         uint64 cnpj; //Brazilian identification of legal entity
100         uint64 idFinancialSupportAgreement; //SCC contract
101         uint32 salic; //ANCINE identifier
102         string idProofHash; //hash of declaration
103         BlockchainAccountState state;
104     } 
105 
106     /**
107         Links Ethereum addresses to LegalEntityInfo        
108      */
109     mapping(address => LegalEntityInfo) public legalEntitiesInfo;
110 
111     /**
112         Links Legal Entity to Ethereum address. 
113         cnpj => (idFinancialSupportAgreement => address)
114      */
115     mapping(uint64 => mapping(uint64 => address)) cnpjFSAddr; 
116 
117 
118     /**
119         Links Ethereum addresses to the possibility to change the account
120         Since the Ethereum account can be changed once, it is not necessary to put the bool to false.
121         TODO: Discuss later what is the best data structure
122      */
123     mapping(address => bool) public legalEntitiesChangeAccount;
124 
125 
126     event AccountRegistration(address addr, uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic, string idProofHash);
127     event AccountChange(address oldAddr, address newAddr, uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic, string idProofHash);
128     event AccountValidation(address addr, uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic);
129     event AccountInvalidation(address addr, uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic);
130 
131     /**
132      * @dev Throws if called by any account other than the token address.
133      */
134     modifier onlyTokenAddress() {
135         require(isTokenAddress());
136         _;
137     }
138 
139     constructor () public {
140         responsibleForSettlement = msg.sender;
141         responsibleForRegistryValidation = msg.sender;
142         responsibleForDisbursement = msg.sender;
143         redemptionAddress = msg.sender;
144     }
145 
146 
147    /**
148     * Link blockchain address with CNPJ - It can be a cliente or a supplier
149     * The link still needs to be validated by BNDES
150     * This method can only be called by BNDESToken contract because BNDESToken can pause.
151     * @param cnpj Brazilian identifier to legal entities
152     * @param idFinancialSupportAgreement contract number of financial contract with BNDES. It assumes 0 if it is a supplier.
153     * @param salic contract number of financial contract with ANCINE. It assumes 0 if it is a supplier.
154     * @param addr the address to be associated with the legal entity.
155     * @param idProofHash The legal entities have to send BNDES a PDF where it assumes as responsible for an Ethereum account. 
156     *                   This PDF is signed with eCNPJ and send to BNDES. 
157     */
158     function registryLegalEntity(uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic, 
159         address addr, string memory idProofHash) onlyTokenAddress public { 
160 
161         // Endereço não pode ter sido cadastrado anteriormente
162         require (isAvailableAccount(addr), "Endereço não pode ter sido cadastrado anteriormente");
163 
164         require (isValidHash(idProofHash), "O hash da declaração é inválido");
165 
166         legalEntitiesInfo[addr] = LegalEntityInfo(cnpj, idFinancialSupportAgreement, salic, idProofHash, BlockchainAccountState.WAITING_VALIDATION);
167         
168         // Não pode haver outro endereço cadastrado para esse mesmo subcrédito
169         if (idFinancialSupportAgreement > 0) {
170             address account = getBlockchainAccount(cnpj,idFinancialSupportAgreement);
171             require (isAvailableAccount(account), "Cliente já está associado a outro endereço. Use a função Troca.");
172         }
173         else {
174             address account = getBlockchainAccount(cnpj,0);
175             require (isAvailableAccount(account), "Fornecedor já está associado a outro endereço. Use a função Troca.");
176         }
177         
178         cnpjFSAddr[cnpj][idFinancialSupportAgreement] = addr;
179 
180         emit AccountRegistration(addr, cnpj, idFinancialSupportAgreement, salic, idProofHash);
181     }
182 
183    /**
184     * Changes the original link between CNPJ and Ethereum account. 
185     * The new link still needs to be validated by BNDES.
186     * This method can only be called by BNDESToken contract because BNDESToken can pause and because there are 
187     * additional instructions there.
188     * @param cnpj Brazilian identifier to legal entities
189     * @param idFinancialSupportAgreement contract number of financial contract with BNDES. It assumes 0 if it is a supplier.
190     * @param salic contract number of financial contract with ANCINE. It assumes 0 if it is a supplier.
191     * @param newAddr the new address to be associated with the legal entity
192     * @param idProofHash The legal entities have to send BNDES a PDF where it assumes as responsible for an Ethereum account. 
193     *                   This PDF is signed with eCNPJ and send to BNDES. 
194     */
195     function changeAccountLegalEntity(uint64 cnpj, uint64 idFinancialSupportAgreement, uint32 salic, 
196         address newAddr, string memory idProofHash) onlyTokenAddress public {
197 
198         address oldAddr = getBlockchainAccount(cnpj, idFinancialSupportAgreement);
199     
200         // Tem que haver um endereço associado a esse cnpj/subcrédito
201         require(!isReservedAccount(oldAddr), "Não pode trocar endereço de conta reservada");
202 
203         require(!isAvailableAccount(oldAddr), "Tem que haver um endereço associado a esse cnpj/subcrédito");
204 
205         require(isAvailableAccount(newAddr), "Novo endereço não está disponível");
206 
207         require (isChangeAccountEnabled(oldAddr), "A conta atual não está habilitada para troca");
208 
209         require (isValidHash(idProofHash), "O hash da declaração é inválido");        
210 
211         require(legalEntitiesInfo[oldAddr].cnpj==cnpj 
212                     && legalEntitiesInfo[oldAddr].idFinancialSupportAgreement ==idFinancialSupportAgreement, 
213                     "Dados inconsistentes de cnpj ou subcrédito");
214 
215         // Aponta o novo endereço para o novo LegalEntityInfo
216         legalEntitiesInfo[newAddr] = LegalEntityInfo(cnpj, idFinancialSupportAgreement, salic, idProofHash, BlockchainAccountState.WAITING_VALIDATION);
217 
218         // Apaga o mapping do endereço antigo
219         legalEntitiesInfo[oldAddr].state = BlockchainAccountState.INVALIDATED_BY_CHANGE;
220 
221         // Aponta mapping CNPJ e Subcredito para newAddr
222         cnpjFSAddr[cnpj][idFinancialSupportAgreement] = newAddr;
223 
224         emit AccountChange(oldAddr, newAddr, cnpj, idFinancialSupportAgreement, salic, idProofHash); 
225 
226     }
227 
228    /**
229     * Validates the initial registry of a legal entity or the change of its registry
230     * @param addr Ethereum address that needs to be validated
231     * @param idProofHash The legal entities have to send BNDES a PDF where it assumes as responsible for an Ethereum account. 
232     *                   This PDF is signed with eCNPJ and send to BNDES. 
233     */
234     function validateRegistryLegalEntity(address addr, string memory idProofHash) public {
235 
236         require(isResponsibleForRegistryValidation(msg.sender), "Somente o responsável pela validação pode validar contas");
237 
238         require(legalEntitiesInfo[addr].state == BlockchainAccountState.WAITING_VALIDATION, "A conta precisa estar no estado Aguardando Validação");
239 
240         require(keccak256(abi.encodePacked(legalEntitiesInfo[addr].idProofHash)) == keccak256(abi.encodePacked(idProofHash)), "O hash recebido é diferente do esperado");
241 
242         legalEntitiesInfo[addr].state = BlockchainAccountState.VALIDATED;
243 
244         emit AccountValidation(addr, legalEntitiesInfo[addr].cnpj, 
245             legalEntitiesInfo[addr].idFinancialSupportAgreement,
246             legalEntitiesInfo[addr].salic);
247     }
248 
249    /**
250     * Invalidates the initial registry of a legal entity or the change of its registry
251     * The invalidation can be called at any time in the lifecycle of the address (not only when it is WAITING_VALIDATION)
252     * @param addr Ethereum address that needs to be validated
253     */
254     function invalidateRegistryLegalEntity(address addr) public {
255 
256         require(isResponsibleForRegistryValidation(msg.sender), "Somente o responsável pela validação pode invalidar contas");
257 
258         require(!isReservedAccount(addr), "Não é possível invalidar conta reservada");
259 
260         legalEntitiesInfo[addr].state = BlockchainAccountState.INVALIDATED_BY_VALIDATOR;
261         
262         emit AccountInvalidation(addr, legalEntitiesInfo[addr].cnpj, 
263             legalEntitiesInfo[addr].idFinancialSupportAgreement,
264             legalEntitiesInfo[addr].salic);
265     }
266 
267 
268    /**
269     * By default, the owner is also the Responsible for Settlement. 
270     * The owner can assign other address to be the Responsible for Settlement. 
271     * @param rs Ethereum address to be assigned as Responsible for Settlement.
272     */
273     function setResponsibleForSettlement(address rs) onlyOwner public {
274         responsibleForSettlement = rs;
275     }
276 
277    /**
278     * By default, the owner is also the Responsible for Validation. 
279     * The owner can assign other address to be the Responsible for Validation. 
280     * @param rs Ethereum address to be assigned as Responsible for Validation.
281     */
282     function setResponsibleForRegistryValidation(address rs) onlyOwner public {
283         responsibleForRegistryValidation = rs;
284     }
285 
286    /**
287     * By default, the owner is also the Responsible for Disbursment. 
288     * The owner can assign other address to be the Responsible for Disbursment. 
289     * @param rs Ethereum address to be assigned as Responsible for Disbursment.
290     */
291     function setResponsibleForDisbursement(address rs) onlyOwner public {
292         responsibleForDisbursement = rs;
293     }
294 
295    /**
296     * The supplier reedems the BNDESToken by transfering the tokens to a specific address, 
297     * called Redemption address. 
298     * By default, the redemption address is the address of the owner. 
299     * The owner can change the redemption address using this function. 
300     * @param rs new Redemption address
301     */
302     function setRedemptionAddress(address rs) onlyOwner public {
303         redemptionAddress = rs;
304     }
305 
306    /**
307     * @param rs Ethereum address to be assigned to the token address.
308     */
309     function setTokenAddress(address rs) onlyOwner public {
310         tokenAddress = rs;
311     }
312 
313    /**
314     * Enable the legal entity to change the account
315     * @param rs account that can be changed.
316     */
317     function enableChangeAccount (address rs) public {
318         require(isResponsibleForRegistryValidation(msg.sender), "Somente o responsável pela validação pode habilitar a troca de conta");
319         legalEntitiesChangeAccount[rs] = true;
320     }
321 
322     function isChangeAccountEnabled (address rs) view public returns (bool) {
323         return legalEntitiesChangeAccount[rs] == true;
324     }    
325 
326     function isTokenAddress() public view returns (bool) {
327         return tokenAddress == msg.sender;
328     } 
329     function isResponsibleForSettlement(address addr) view public returns (bool) {
330         return (addr == responsibleForSettlement);
331     }
332     function isResponsibleForRegistryValidation(address addr) view public returns (bool) {
333         return (addr == responsibleForRegistryValidation);
334     }
335     function isResponsibleForDisbursement(address addr) view public returns (bool) {
336         return (addr == responsibleForDisbursement);
337     }
338     function isRedemptionAddress(address addr) view public returns (bool) {
339         return (addr == redemptionAddress);
340     }
341 
342     function isReservedAccount(address addr) view public returns (bool) {
343 
344         if (isOwner(addr) || isResponsibleForSettlement(addr) 
345                            || isResponsibleForRegistryValidation(addr)
346                            || isResponsibleForDisbursement(addr)
347                            || isRedemptionAddress(addr) ) {
348             return true;
349         }
350         return false;
351     }
352     function isOwner(address addr) view public returns (bool) {
353         return owner()==addr;
354     }
355 
356     function isSupplier(address addr) view public returns (bool) {
357 
358         if (isReservedAccount(addr))
359             return false;
360 
361         if (isAvailableAccount(addr))
362             return false;
363 
364         return legalEntitiesInfo[addr].idFinancialSupportAgreement == 0;
365     }
366 
367     function isValidatedSupplier (address addr) view public returns (bool) {
368         return isSupplier(addr) && (legalEntitiesInfo[addr].state == BlockchainAccountState.VALIDATED);
369     }
370 
371     function isClient (address addr) view public returns (bool) {
372         if (isReservedAccount(addr)) {
373             return false;
374         }
375         return legalEntitiesInfo[addr].idFinancialSupportAgreement != 0;
376     }
377 
378     function isValidatedClient (address addr) view public returns (bool) {
379         return isClient(addr) && (legalEntitiesInfo[addr].state == BlockchainAccountState.VALIDATED);
380     }
381 
382     function isAvailableAccount(address addr) view public returns (bool) {
383         if ( isReservedAccount(addr) ) {
384             return false;
385         } 
386         return legalEntitiesInfo[addr].state == BlockchainAccountState.AVAILABLE;
387     }
388 
389     function isWaitingValidationAccount(address addr) view public returns (bool) {
390         return legalEntitiesInfo[addr].state == BlockchainAccountState.WAITING_VALIDATION;
391     }
392 
393     function isValidatedAccount(address addr) view public returns (bool) {
394         return legalEntitiesInfo[addr].state == BlockchainAccountState.VALIDATED;
395     }
396 
397     function isInvalidatedByValidatorAccount(address addr) view public returns (bool) {
398         return legalEntitiesInfo[addr].state == BlockchainAccountState.INVALIDATED_BY_VALIDATOR;
399     }
400 
401     function isInvalidatedByChangeAccount(address addr) view public returns (bool) {
402         return legalEntitiesInfo[addr].state == BlockchainAccountState.INVALIDATED_BY_CHANGE;
403     }
404 
405     function getResponsibleForSettlement() view public returns (address) {
406         return responsibleForSettlement;
407     }
408     function getResponsibleForRegistryValidation() view public returns (address) {
409         return responsibleForRegistryValidation;
410     }
411     function getResponsibleForDisbursement() view public returns (address) {
412         return responsibleForDisbursement;
413     }
414     function getRedemptionAddress() view public returns (address) {
415         return redemptionAddress;
416     }
417     function getCNPJ(address addr) view public returns (uint64) {
418         return legalEntitiesInfo[addr].cnpj;
419     }
420 
421     function getIdLegalFinancialAgreement(address addr) view public returns (uint64) {
422         return legalEntitiesInfo[addr].idFinancialSupportAgreement;
423     }
424 
425     function getLegalEntityInfo (address addr) view public returns (uint64, uint64, uint32, string memory, uint, address) {
426         return (legalEntitiesInfo[addr].cnpj, legalEntitiesInfo[addr].idFinancialSupportAgreement, 
427              legalEntitiesInfo[addr].salic, legalEntitiesInfo[addr].idProofHash, (uint) (legalEntitiesInfo[addr].state),
428              addr);
429     }
430 
431     function getBlockchainAccount(uint64 cnpj, uint64 idFinancialSupportAgreement) view public returns (address) {
432         return cnpjFSAddr[cnpj][idFinancialSupportAgreement];
433     }
434 
435     function getLegalEntityInfoByCNPJ (uint64 cnpj, uint64 idFinancialSupportAgreement) 
436         view public returns (uint64, uint64, uint32, string memory, uint, address) {
437         
438         address addr = getBlockchainAccount(cnpj,idFinancialSupportAgreement);
439         return getLegalEntityInfo (addr);
440     }
441 
442     function getAccountState(address addr) view public returns (int) {
443 
444         if ( isReservedAccount(addr) ) {
445             return 100;
446         } 
447         else {
448             return ((int) (legalEntitiesInfo[addr].state));
449         }
450 
451     }
452 
453 
454   function isValidHash(string memory str) pure public returns (bool)  {
455 
456     bytes memory b = bytes(str);
457     if(b.length != 64) return false;
458 
459     for (uint i=0; i<64; i++) {
460         if (b[i] < "0") return false;
461         if (b[i] > "9" && b[i] <"a") return false;
462         if (b[i] > "f") return false;
463     }
464         
465     return true;
466  }
467 
468 
469 }