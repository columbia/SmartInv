1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
5 }
6 
7 contract DarchNetwork {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     uint256 public totalSupply;
13     address public fundsWallet;
14     uint256 public firstcaplimit = 0;
15     uint256 public secondcaplimit = 0;
16     uint256 public thirdcaplimit = 0;
17     uint256 public lastcaplimit = 0;
18 
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23     event Burn(address indexed from, uint256 value);
24 
25 
26     constructor(
27         uint256 initialSupply,
28         string memory tokenName,
29         string memory tokenSymbol
30     ) public {
31         initialSupply = 1000000000;
32         tokenName = "Darch Network";
33         tokenSymbol = "DARCH";
34         fundsWallet = msg.sender;
35         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
36         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
37         name = tokenName;                                   // Set the name for display purposes
38         symbol = tokenSymbol;                               // Set the symbol for display purposes
39 
40     }
41 
42 
43     function _transfer(address _from, address _to, uint _value) internal {
44         require(_to != address(0x0));
45         require(balanceOf[_from] >= _value);
46         require(balanceOf[_to] + _value >= balanceOf[_to]);
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         balanceOf[_from] -= _value;
49         balanceOf[_to] += _value;
50         emit Transfer(_from, _to, _value);
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54 
55     function transfer(address _to, uint256 _value) public returns (bool success) {
56         _transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60 
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62         require(_value <= allowance[_from][msg.sender]);     // Check allowance
63         allowance[_from][msg.sender] -= _value;
64         _transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function approve(address _spender, uint256 _value) public
69         returns (bool success) {
70         allowance[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75 
76     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
77         public
78         returns (bool success) {
79         tokenRecipient spender = tokenRecipient(_spender);
80         if (approve(_spender, _value)) {
81             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
82             return true;
83         }
84     }
85 
86 
87     function burn(uint256 _value) public returns (bool success) {
88         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
89         balanceOf[msg.sender] -= _value;            // Subtract from the sender
90         totalSupply -= _value;                      // Updates totalSupply
91         emit Burn(msg.sender, _value);
92         return true;
93     }
94 
95 
96     function burnFrom(address _from, uint256 _value) public returns (bool success) {
97         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
98         require(_value <= allowance[_from][msg.sender]);    // Check allowance
99         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
100         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
101         totalSupply -= _value;                              // Update totalSupply
102         emit Burn(_from, _value);
103         return true;
104     }
105 
106 
107 
108 
109     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
110         if (_i == 0) {
111             return "0";
112         }
113         uint j = _i;
114         uint len;
115         while (j != 0) {
116             len++;
117             j /= 10;
118         }
119         bytes memory bstr = new bytes(len);
120         uint k = len - 1;
121         while (_i != 0) {
122             bstr[k--] = byte(uint8(48 + _i % 10));
123             _i /= 10;
124         }
125         return string(bstr);
126     }
127     uint private productId;
128     function getProductID() private returns (uint256) {
129     return productId++;
130     }
131 
132     uint private requestID;
133     function getRequestID() private returns (uint256) {
134     return requestID++;
135     }
136 
137 
138     struct productDetails {
139       uint time;
140       string headline;
141       string explain;
142       string imagelist;
143       string showdemo;
144       string category;
145       address senderaddress;
146       uint256 pid;
147       uint256 price;
148     }
149 
150     mapping (string => productDetails) newProduct;
151     string[] public listofproducts;
152 
153     function SharenewProduct(string memory uHeadline, string memory uExplain, string memory uImageList, string memory uShowDemo,string memory uCate, uint uPrice, string memory pname) public {
154 
155         uint256 newpid = getProductID();
156         newProduct[pname].time = now;
157         newProduct[pname].senderaddress = msg.sender;
158         newProduct[pname].headline = uHeadline;
159         newProduct[pname].explain = uExplain;
160         newProduct[pname].imagelist = uImageList;
161         newProduct[pname].showdemo = uShowDemo;
162         newProduct[pname].category = uCate;
163         newProduct[pname].pid = newpid;
164         newProduct[pname].price = uPrice;
165         listofproducts.push(pname) -1;
166     }
167 
168 
169 
170 
171 
172     function numberofProduct() view public returns (uint) {
173       return listofproducts.length;
174     }
175 
176     function getpnamefromid(uint _pid) view public returns (string memory){
177         return listofproducts[_pid];
178     }
179 
180 
181     function getProductFromName(string memory pname) view public returns (string memory, string memory,string memory, string memory, string memory, string memory, string memory) {
182 
183         if(newProduct[pname].time == 0){
184             return ("0", "0", "0","0","0","0","0");
185         } else {
186         return (uint2str(newProduct[pname].time), uint2str(newProduct[pname].price), newProduct[pname].headline, newProduct[pname].explain, newProduct[pname].imagelist, newProduct[pname].showdemo, newProduct[pname].category);
187         }
188     }
189 
190 
191     function checkProductExist(string memory pname) view public returns (bool) {
192 
193         if(newProduct[pname].time == 0){
194             return false;
195         } else {
196             return true;
197         }
198     }
199 
200 
201 
202 
203 
204   struct Requesters {
205       bool exists;
206       uint256 ptime;
207       string publicKey;
208       address rqaddress;
209   }
210 
211   mapping(string => Requesters[]) rlist;
212   mapping (string => bool) public RWlist;
213   string[] public listofrequests;
214 
215  function checkWalletexist(string memory _wallet) view public returns (bool){
216         return RWlist[_wallet];
217  }
218 
219 
220   function setNewRequest(string memory pname, string memory pubkey) public returns (uint)  {
221       bool checkProduct = checkProductExist(pname);
222       if(checkProduct){
223           string memory wid = appendString(WallettoString(msg.sender),pname);
224 
225           bool cwallet = checkWalletexist(wid);
226 
227           if(cwallet){
228               revert();
229           } else {
230             if(balanceOf[msg.sender] >= newProduct[pname].price) {
231               transfer(fundsWallet, newProduct[pname].price);
232               RWlist[wid]=true;
233               rlist[pname].push(Requesters(true,now, pubkey, msg.sender));
234               listofproducts.push(wid) -1;
235               return rlist[pname].length - 1;
236             } else {
237                 revert();
238             }
239 
240           }
241       } else {
242           revert();
243       }
244 
245   }
246 
247 
248 
249     function num_of_request() view public returns (uint) {
250       return listofproducts.length;
251     }
252 
253     function get_product_from_pid(uint _listid) view public returns (string memory){
254         return listofproducts[_listid];
255     }
256 
257 
258    function num_of_product_requests(string memory key) public view returns (uint) {
259     return rlist[key].length;
260   }
261 
262   function get_public_key(string memory key, uint index) public view returns (string memory) {
263     if (rlist[key][index].exists == false) {
264       assert(false);
265     }
266     return rlist[key][index].publicKey;
267   }
268 
269 
270    struct TransmitProduct {
271       bool exists;
272       bool status;
273       uint256 ptime;
274       string signedMessage;
275       address forwho;
276   }
277 
278   mapping(string => TransmitProduct[]) responseList;
279   mapping (string => bool) public BWlist;
280   string[] public listoftransmits;
281 
282 
283   function checkBWalletexist(string memory _walletandid) view public returns (bool){
284         return BWlist[_walletandid];
285   }
286 
287   function WallettoString(address x) public returns(string memory) {
288     bytes memory b = new bytes(20);
289     for (uint i = 0; i < 20; i++)
290         b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
291     return string(b);
292  }
293 
294  function appendString(string memory a, string memory b) internal pure returns (string memory) {
295     return string(abi.encodePacked(a, b));
296 }
297 
298 
299 
300    function setTransmitProduct(string memory pname, uint index, string memory smessage) payable public  {
301       bool checkProduct = checkProductExist(pname);
302       if(checkProduct){
303           address radress = rlist[pname][index].rqaddress;
304           string memory wid = appendString(WallettoString(radress),pname);
305           bool cwallet = checkBWalletexist(wid);
306 
307           if(cwallet){
308               //Buraya geliyorsa daha önce zaten göndermiş demektir.
309               revert();
310           } else {
311 
312               if(msg.sender == newProduct[pname].senderaddress){
313 
314                 require(balanceOf[fundsWallet] >= newProduct[pname].price);
315                 _transfer(fundsWallet, msg.sender, newProduct[pname].price);
316 
317                 BWlist[wid]=true;
318                 //Sadece alıcının çözüleceği şekilde istek şifrelenerek blockchaine yükleniyor.
319                 responseList[pname].push(TransmitProduct(true, true, now, smessage, radress));
320                 listoftransmits.push(wid) -1;
321               } else {
322                   revert();
323               }
324           }
325       } else {
326           revert();
327       }
328 
329   }
330 
331 
332 
333   function cancelTransmitProduct(string memory pname, uint index) public  {
334       bool checkProduct = checkProductExist(pname);
335       if(checkProduct){
336           address radress = rlist[pname][index].rqaddress;
337           string memory wid = appendString(WallettoString(radress),pname);
338           bool cwallet = checkBWalletexist(wid);
339 
340 
341           if(cwallet){
342               //Buraya geliyorsa daha önce zaten göndermiş demektir.
343               revert();
344           } else {
345               //Eğer önceden gönderim yapılmamışsa burası çalışır.
346               //rqaddress
347               if(msg.sender == rlist[pname][index].rqaddress){
348                 //Sadece o ürüne istek gönderen kişi iptal edebilir.
349 
350                 //coin kontrattan iptal edene iletiliyor.
351 
352                  require(balanceOf[fundsWallet] >= newProduct[pname].price);
353 
354                 _transfer(fundsWallet,msg.sender,newProduct[pname].price);
355 
356 
357                 BWlist[wid]=true;
358                 //status false olması ürünün iptal edildiği anlamına geliyor.
359                 //Gönderici parasını alıyor ve ürün
360                 responseList[pname].push(TransmitProduct(true, false, now, "canceled", radress));
361                 listoftransmits.push(wid) -1;
362               } else {
363                   revert();
364               }
365           }
366       } else {
367           revert();
368       }
369 
370   }
371 
372 
373 
374 
375 
376     function num_of_transmit() view public returns (uint) {
377       return listoftransmits.length;
378     }
379 
380     function get_transmits_from_pid(uint _listid) view public returns (string memory){
381         return listoftransmits[_listid];
382     }
383 
384   function num_of_product_transmit(string memory _pid) public view returns (uint) {
385     return responseList[_pid].length;
386   }
387 
388   function getTransmits(string memory _pid, uint index) public view returns (address) {
389     if (responseList[_pid][index].exists == false) {
390       assert(false);
391     }
392     return rlist[_pid][index].rqaddress;
393   }
394 
395 
396 
397 
398 
399 
400     function() payable external{
401       uint256 yirmimart = 1553040000;
402       uint256 onnisan = 1554854400;
403       uint256 birmayis = 1556668800;
404       uint256 yirmimayis = 1558310400;
405       uint256 onhaziran = 1560124800;
406 
407       if(yirmimart > now) {
408         require(balanceOf[fundsWallet] >= msg.value * 100);
409         _transfer(fundsWallet, msg.sender, msg.value * 100);
410 
411       } else if(yirmimart < now && onnisan > now) {
412 
413         if(firstcaplimit < 75000000){
414         require(balanceOf[fundsWallet] >= msg.value * 15000);
415         firstcaplimit = firstcaplimit +  msg.value * 15000;
416         _transfer(fundsWallet, msg.sender, msg.value * 15000);
417         } else {
418           assert(false);
419         }
420       } else if(onnisan < now && birmayis > now) {
421 
422         if(secondcaplimit < 75000000){
423         require(balanceOf[fundsWallet] >= msg.value * 12000);
424         secondcaplimit = firstcaplimit +  msg.value * 12000;
425         _transfer(fundsWallet, msg.sender, msg.value * 12000);
426         } else {
427           assert(false);
428         }
429       }else if(birmayis < now && yirmimayis > now) {
430        if(thirdcaplimit < 75000000){
431         require(balanceOf[fundsWallet] >= msg.value * 10000);
432         thirdcaplimit = firstcaplimit +  msg.value * 10000;
433         _transfer(fundsWallet, msg.sender, msg.value * 10000); // Broadcast a message to the blockchain
434         } else {
435           assert(false);
436         }
437       }else if(yirmimayis < now && onhaziran > now) {
438       if(lastcaplimit < 75000000){
439         require(balanceOf[fundsWallet] >= msg.value * 7500);
440         lastcaplimit = firstcaplimit +  msg.value * 7500;
441         _transfer(fundsWallet, msg.sender, msg.value * 7500);
442         } else {
443           assert(false);
444         }
445       } else {
446         assert(false);
447       }
448 
449     }
450 
451 }