1 pragma solidity >=0.4.25;
2 
3 library AddressUtils {
4 
5 
6   function isContract(address addr) internal view returns (bool) {
7     uint256 size;
8     // XXX Currently there is no better way to check if there is a contract in an address
9     // than to check the size of the code at that address.
10     // See https://ethereum.stackexchange.com/a/14016/36603
11     // for more details about how this works.
12     // TODO Check this again before the Serenity release, because all addresses will be
13     // contracts then.
14     // solium-disable-next-line security/no-inline-assembly
15     assembly { size := extcodesize(addr) }
16     return size > 0;
17   }
18 
19 }
20 
21 contract ERC20Interface {
22     function allowance(address _from, address _to) public view returns(uint);
23     function transferFrom(address _from, address _to, uint _sum) public;
24     function transfer(address _to, uint _sum) public;
25     function balanceOf(address _owner) public view returns(uint);
26 }
27 
28 contract WalletInterface {
29     function getTransaction(uint _id) public view returns(address, uint, address, uint, uint, bool);
30 }
31 
32 contract ContractCreator {
33     function setContract() public returns(address);
34 }
35 
36 contract MaxiCreditCompany {
37     
38     event Transfer(address indexed _from, address indexed _to, uint _sum);
39     event TokenBoughtFromContract(address indexed _buyer, uint indexed _promoter, uint _sum);
40     event TokenBoughtFromSeller(address indexed _buyer, address _seller, uint _amount, uint indexed _offerId);
41     event Approval(address indexed _seller, address indexed _buyer, uint _amount);
42     event DescriptionChange(bytes32 _txt);
43     event NewServer(address indexed _serverAddress, uint indexed _id);
44     event ServerChanged(address indexed _newServerAddress, address indexed _oldServerAddress, uint indexed _id);
45     event ETHWithdraw(address indexed _to, uint _sum);
46     event ERC20Withdraw(address indexed _erc20Address, address indexed _to, uint _sum);
47     event SupplyIncreased(uint _amount, uint _totalSupply);
48     event NewSaleOffer(uint indexed saleOffersCounter, uint indexed _amount, uint indexed _unitPrice);
49     event SetToBuyBack(uint _amount, uint _price);
50     event BuyBack(uint indexed _amount, uint indexed buyBackPrice);
51     event SetOwner(uint indexed _id, address indexed _newOwner);
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53     event OwnerDeleted(uint indexed _id, address indexed _owner);
54     event OperatorRightChanged(address indexed _operator, uint _txRight);
55     event NewOperator(uint indexed _id, address indexed _newOperator, uint _txRight);
56     event OperatorChanged(uint indexed _id, address indexed _newOperator, address indexed oldOperator, uint _txRight);
57     event DeleteOperator(uint indexed _id, address indexed _operator);
58     event OwnerChangedPrice(uint _priceETH, uint _priceUSD);
59     event ServerChangedPrice(uint _priceETH, uint _priceUSD);
60     event NewContract(address indexed _addr, uint indexed newContractsLength);
61     
62     using AddressUtils for address;
63     string public name = "MaxiCreditCompanyShare";
64     string public symbol = "MC2";
65     uint public supply = 80000000;
66     uint public decimals = 0;
67     bytes32 public description;
68     
69     uint public unitPriceETH; 
70     uint public unitPriceUSD;
71     uint public shareHoldersNumber;
72     mapping (address => uint) shareHolderId;
73     address[] public shareHolders;
74     bool shareHolderDelete;
75     address[10] public contractOwner;
76     address[10] public operator;
77     uint public ownerCounter;
78     
79     mapping(address => bool) public isOwner;
80     mapping(address => bool) public isOperator;
81     mapping(address => uint) public operatorsRights;
82 
83     mapping(address => uint) public balanceOf;
84     mapping(address => mapping(uint => uint)) public saleOffersByAddress;
85     mapping(uint => address) public saleOffersById;
86     mapping(uint => uint) public saleOffersAmount;
87     mapping(uint => uint) public saleOffersUnitPrice;
88     mapping(address => uint) public sellersOfferCounter;
89     uint public saleOffersCounter = 0;
90     
91     uint public buyBackAmount = 0;
92     uint public buyBackPrice = 0;
93     
94     mapping(address => mapping(address => uint)) public approvedTransfers;
95     
96     address[] serverAddress;
97     mapping (address => bool) isOurServer;
98     uint serverAddressArrayLength;
99     
100     ContractCreator cc;
101     address newContract;
102     address[] public newContracts;
103     uint public newContractsLength;
104 
105     modifier onlyOwner() {
106         require(isOwner[msg.sender] == true);
107         require(msg.sender != address(0));
108         _;
109     }  
110     
111     modifier onlyOperator() {
112         require(isOperator[msg.sender] == true);
113         require(msg.sender != address(0));
114         _;
115     }
116     
117     modifier onlyServer() {
118         require(isOurServer[msg.sender] == true);
119         require(msg.sender != address(0));
120         _;
121     }
122     
123     constructor (uint _initPriceETH, uint _initPriceUSD) public {
124        contractOwner[0] = msg.sender;
125        isOwner[msg.sender] = true;
126        operator[0] = msg.sender;
127        isOperator[msg.sender] = true;
128        operatorsRights[msg.sender] = 100;
129        balanceOf[address(this)] = supply;
130        unitPriceETH = _initPriceETH;
131        unitPriceUSD = _initPriceUSD;
132        shareHoldersNumber = 0;
133        shareHolderDelete = false;
134        ownerCounter = 1;
135     }
136     
137     function getContractOwner(uint _id) public view returns(address) {
138         return(contractOwner[_id]);
139     }
140     
141     function setDescription(bytes32 _txt) public onlyOwner {
142         description = _txt;
143         emit DescriptionChange(_txt);
144     }
145     
146     function setServerAddress(address _serverAddress) public onlyOwner {
147         serverAddressArrayLength = serverAddress.push(_serverAddress);
148         isOurServer[_serverAddress] = true;
149         emit NewServer(_serverAddress, serverAddressArrayLength - 1);
150     }
151     
152     function modifyServer(uint _id, address _serverAddress) public onlyOwner {
153         address oldServer = serverAddress[_id];
154         isOurServer[serverAddress[_id]] = false;
155         serverAddress[_id] = _serverAddress;
156         isOurServer[_serverAddress] = true;
157         emit ServerChanged(_serverAddress, oldServer, _id);
158     }
159     
160     function getServerAddressLength() public view onlyOperator returns(uint) {
161         return serverAddressArrayLength;
162     }
163     
164     function getServerAddress(uint _num) public view onlyOperator returns(address) {
165         return serverAddress[_num];
166     }
167     
168     function checkServerAddress(address _addr) public view onlyOperator returns(bool) {
169         return(isOurServer[_addr]);
170     }
171     
172     function withdrawal(uint _sum, address _to) public onlyOperator {
173         require(operatorsRights[msg.sender] * address(this).balance / 100 >= _sum);
174         require(address(this).balance >= _sum);
175         require(_to != address(0) && _sum > 0);
176         address(_to).transfer(_sum);
177         emit ETHWithdraw(_to, _sum);
178     }
179     
180     function withdrawERC20(address _erc20Address, address _to, uint _amount) public onlyOperator {
181         ERC20Interface ei = ERC20Interface(_erc20Address);
182         require(operatorsRights[msg.sender] * ei.balanceOf(this) / 100 >= _amount);
183         require(_erc20Address != address(0) && _to != address(0));
184         ei.transfer(_to, _amount);
185         emit ERC20Withdraw(_erc20Address, _to, _amount);
186     }
187     /*
188     */
189     function totalSupply() public view returns(uint) {
190         return(supply);
191     }
192     
193     function increaseSupply(uint _amount) public onlyOwner {
194         supply += _amount;
195         balanceOf[this] += _amount;
196         emit SupplyIncreased(_amount, supply);
197     }
198     
199     function _transfer(address _from, address _to, uint _sum) private {
200         require(_from != address(0));
201         require(_to != address(0));
202         require(_from != _to);
203         require(_sum > 0);
204         require(balanceOf[_from] >= _sum);
205         require(balanceOf[_to] + _sum >= _sum);
206         if(balanceOf[_to] == 0) {
207             shareHolderId[_to] = shareHoldersNumber;
208             if(shareHolderDelete) {
209                 shareHolders[shareHoldersNumber] = _to;
210                 shareHolderDelete = false;
211             } else {
212                 shareHolders.push(_to);    
213             }
214             shareHoldersNumber ++;
215         }
216         uint sumBalanceBeforeTx = balanceOf[_from] + balanceOf[_to]; 
217         balanceOf[_from] -= _sum;
218         balanceOf[_to] += _sum;
219         if(balanceOf[_from] == 0) {
220             shareHoldersNumber --;
221             shareHolders[shareHolderId[_from]] = shareHolders[shareHoldersNumber];
222             shareHolderId[shareHolders[shareHoldersNumber]] = shareHolderId[_from];
223             delete shareHolders[shareHoldersNumber];
224             shareHolderDelete = true;
225         }
226         assert(sumBalanceBeforeTx == balanceOf[_from] + balanceOf[_to]);
227         emit Transfer(_from, _to, _sum);
228     }
229     
230     function transfer(address _to, uint _sum) external returns(bool) {
231         _transfer(msg.sender, _to, _sum);
232         return(true);
233     }
234     
235     function transferFromContractsBalance(address _to, uint _sum) public onlyOwner {
236         require(_to != address(0));
237         require(this != _to);
238         require(_sum > 0);
239         require(balanceOf[this] >= _sum);
240         require(balanceOf[_to] + _sum >= _sum);
241         if(balanceOf[_to] == 0) {
242             shareHolderId[_to] = shareHoldersNumber;
243             if(shareHolderDelete) {
244                 shareHolders[shareHoldersNumber] = _to;
245                 shareHolderDelete = false;
246             } else {
247                 shareHolders.push(_to);    
248             }   
249             shareHoldersNumber ++;
250         }
251         uint sumBalanceBeforeTx = balanceOf[this] + balanceOf[_to]; 
252         balanceOf[this] -= _sum;
253         balanceOf[_to] += _sum;
254         assert(sumBalanceBeforeTx == balanceOf[this] + balanceOf[_to]);
255         emit Transfer(this, _to, _sum);
256     }
257 
258     function setToSale(uint _amount, uint _unitPrice) public {
259         require(balanceOf[msg.sender] >= _amount);
260         require(_unitPrice > 0);
261         saleOffersByAddress[msg.sender][sellersOfferCounter[msg.sender]] = saleOffersCounter;
262         saleOffersById[saleOffersCounter] = msg.sender;
263         saleOffersAmount[saleOffersCounter] = _amount;
264         saleOffersUnitPrice[saleOffersCounter] = _unitPrice;
265         emit NewSaleOffer(saleOffersCounter, _amount, _unitPrice);
266         sellersOfferCounter[msg.sender] ++;
267         saleOffersCounter ++;
268     }
269     
270     function getSaleOffer(uint _id) public view returns(address, uint, uint) {
271         return(saleOffersById[_id], saleOffersAmount[_id], saleOffersUnitPrice[_id]);
272     }
273     
274     function buyFromSeller(uint _amount, uint _offerId) public payable {
275         require(saleOffersAmount[_offerId] >= _amount);
276         uint orderPrice = _amount * saleOffersUnitPrice[_offerId];
277         require(msg.value == orderPrice);
278         saleOffersAmount[_offerId] -= _amount;
279         _transfer(saleOffersById[_offerId], msg.sender, _amount);
280         uint sellersShare = orderPrice * 99 / 100;
281         uint toSend = sellersShare;
282         sellersShare = 0;
283         saleOffersById[_offerId].transfer(toSend);
284         emit TokenBoughtFromSeller(msg.sender, saleOffersById[_offerId], _amount, _offerId);
285     }
286     
287     function setBuyBack(uint _amount, uint _price) public onlyOperator {
288         buyBackAmount += _amount;
289         buyBackPrice = _price;
290         emit SetToBuyBack(_amount, _price);
291     }
292 
293     function buyback(uint _amount) public {
294         require(buyBackAmount >= _amount);
295         buyBackAmount -= _amount;
296         _transfer(msg.sender, this, _amount);
297         msg.sender.transfer(_amount * buyBackPrice); 
298         emit BuyBack(_amount, buyBackPrice);
299     }
300     
301     function getETH(uint _amount) public payable {
302         require(msg.value == _amount);
303         //event?
304     }
305     
306     //should be different function for set and modify owner and operator
307     function setContractOwner(uint _id, address _newOwner) public onlyOwner {
308         require(contractOwner[_id] == address(0) && !isOwner[_newOwner]);
309         contractOwner[_id] = _newOwner;
310         isOwner[_newOwner] = true;
311         ownerCounter++;
312         emit SetOwner(_id, _newOwner);
313     }
314     
315     function modifyContractOwner(uint _id, address _newOwner) public onlyOwner {
316         require(contractOwner[_id] != address(0) && contractOwner[_id] != _newOwner);
317         address previousOwner = contractOwner[_id];
318         isOwner[contractOwner[_id]] = false;
319         contractOwner[_id] = _newOwner;
320         isOwner[_newOwner] = true;
321         emit OwnershipTransferred(previousOwner, _newOwner);
322     }
323     
324     function deleteOwner(uint _id, address _addr) public onlyOwner {
325         require(ownerCounter > 1);
326         require(isOwner[_addr] && contractOwner[_id] == _addr);
327         isOwner[_addr] = false;
328         contractOwner[_id] = address(0);
329         ownerCounter--;
330         emit OwnerDeleted(_id, _addr);
331     }
332     
333     function setOperatorsRight(address _operator, uint _txRight) public onlyOwner {
334         require(_txRight <= 100 && isOperator[_operator]);
335         operatorsRights[_operator] = _txRight;
336         emit OperatorRightChanged(_operator, _txRight);
337     }
338     
339     function setOperator(uint _id, address _newOperator, uint _txRight) public onlyOwner {
340         require(_txRight <= 100 && operator[_id] == address(0) && !isOperator[_newOperator]);
341         operator[_id] = _newOperator;
342         operatorsRights[_newOperator] = _txRight;
343         isOperator[_newOperator] = true;
344         emit NewOperator(_id, _newOperator, _txRight);
345     }
346     
347     function modifyOperator(uint _id, address _newOperator, uint _txRight) public onlyOwner {
348         require(operator[_id] != address(0) && operator[_id] != _newOperator && _txRight < 100);
349         address oldOperator = operator[_id];
350         isOperator[operator[_id]] = false;
351         operatorsRights[operator[_id]] = 0;
352         isOperator[_newOperator] = true;
353         operator[_id] = _newOperator;
354         operatorsRights[_newOperator] = _txRight;
355         emit OperatorChanged(_id, _newOperator, oldOperator, _txRight);
356     }
357     
358     function deleteOperator(uint _id, address _operator) public onlyOwner {
359         require(isOperator[_operator] && operator[_id] == _operator);
360         isOperator[_operator] = false;
361         operatorsRights[_operator] = 0;
362         operator[_id] = address(0);
363         emit DeleteOperator(_id, _operator);
364     }
365 
366     function getShareNumber(address _addr) public view returns(uint) {
367         return(balanceOf[_addr]);
368     }
369 
370     function approve(address _to, uint _sum) public {
371         approvedTransfers[msg.sender][_to] += _sum;
372         emit Approval(msg.sender, _to, _sum);
373     }
374     
375     function allowance(address _from, address _to) public view returns(uint) {
376         return (approvedTransfers[_from][_to]);
377     }
378     
379     function transferFrom(address _from, address _to, uint _sum) public { 
380         require(approvedTransfers[_from][msg.sender] >= _sum);
381         approvedTransfers[_from][msg.sender] -= _sum;
382         _transfer(_from, _to, _sum); 
383     }
384 
385     function changePriceByOwner(uint _priceETH, uint _priceUSD) public onlyOwner {
386         require(_priceETH > 0 && _priceUSD > 0);
387         unitPriceETH = _priceETH;
388         unitPriceUSD = _priceUSD;
389         emit OwnerChangedPrice(_priceETH, _priceUSD);
390     }
391     
392     function changePriceByServer(uint _priceETH, uint _priceUSD) public onlyServer {
393         require(_priceETH > 0 && _priceUSD > 0);
394         unitPriceETH = _priceETH;
395         unitPriceUSD = _priceUSD;
396         emit ServerChangedPrice(_priceETH, _priceUSD);
397     }
398     
399     function checkIsShareHolder() public view returns(bool){
400         if(balanceOf[msg.sender] > 0) {
401             return(true);
402         } else {
403             return(false);
404         }
405     } 
406     
407     function getShareHolderRegister() public view returns(address[] memory) {
408         return(shareHolders);
409     }
410     
411     function setNewContract(address _addr) public onlyOperator {
412         cc = ContractCreator(_addr);
413         newContract = cc.setContract();
414         newContracts.push(newContract);
415         newContractsLength ++;
416         emit NewContract(_addr, newContractsLength);
417     }
418 }