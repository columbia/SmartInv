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
13     address payable public fundsWallet;
14 
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19     event Burn(address indexed from, uint256 value);
20 
21 
22     constructor(
23         uint256 initialSupply,
24         string memory tokenName,
25         string memory tokenSymbol
26     ) public {
27         initialSupply = 1000000000;
28         tokenName = "Darch Network";
29         tokenSymbol = "DARCH";
30         fundsWallet = msg.sender;
31         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
33         name = tokenName;                                   // Set the name for display purposes
34         symbol = tokenSymbol;                               // Set the symbol for display purposes
35 
36     }
37 
38 
39     function _transfer(address _from, address _to, uint _value) internal {
40         require(_to != address(0x0));
41         require(balanceOf[_from] >= _value);
42         require(balanceOf[_to] + _value >= balanceOf[_to]);
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         balanceOf[_from] -= _value;
45         balanceOf[_to] += _value;
46         emit Transfer(_from, _to, _value);
47         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
48     }
49 
50 
51     function transfer(address _to, uint256 _value) public returns (bool success) {
52         _transfer(msg.sender, _to, _value);
53         return true;
54     }
55 
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);     // Check allowance
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function approve(address _spender, uint256 _value) public
65         returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         emit Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71 
72     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
73         public
74         returns (bool success) {
75         tokenRecipient spender = tokenRecipient(_spender);
76         if (approve(_spender, _value)) {
77             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
78             return true;
79         }
80     }
81 
82 
83     function burn(uint256 _value) public returns (bool success) {
84         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
85         balanceOf[msg.sender] -= _value;            // Subtract from the sender
86         totalSupply -= _value;                      // Updates totalSupply
87         emit Burn(msg.sender, _value);
88         return true;
89     }
90 
91 
92     function burnFrom(address _from, uint256 _value) public returns (bool success) {
93         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
94         require(_value <= allowance[_from][msg.sender]);    // Check allowance
95         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
96         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
97         totalSupply -= _value;                              // Update totalSupply
98         emit Burn(_from, _value);
99         return true;
100     }
101 
102 
103 
104 
105     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
106         if (_i == 0) {
107             return "0";
108         }
109         uint j = _i;
110         uint len;
111         while (j != 0) {
112             len++;
113             j /= 10;
114         }
115         bytes memory bstr = new bytes(len);
116         uint k = len - 1;
117         while (_i != 0) {
118             bstr[k--] = byte(uint8(48 + _i % 10));
119             _i /= 10;
120         }
121         return string(bstr);
122     }
123     uint private productId;
124     function getProductID() private returns (uint256) {
125     return productId++;
126     }
127 
128     uint private requestID;
129     function getRequestID() private returns (uint256) {
130     return requestID++;
131     }
132 
133 
134     struct productDetails {
135       uint time;
136       string headline;
137       string explain;
138       string imagelist;
139       string showdemo;
140       string category;
141       address senderaddress;
142       uint256 pid;
143       uint256 price;
144     }
145 
146     mapping (string => productDetails) newProduct;
147     string[] public listofproducts;
148 
149     function SharenewProduct(string memory uHeadline, string memory uExplain, string memory uImageList, string memory uShowDemo,string memory uCate, uint uPrice, string memory pname) public {
150 
151         uint256 newpid = getProductID();
152         newProduct[pname].time = now;
153         newProduct[pname].senderaddress = msg.sender;
154         newProduct[pname].headline = uHeadline;
155         newProduct[pname].explain = uExplain;
156         newProduct[pname].imagelist = uImageList;
157         newProduct[pname].showdemo = uShowDemo;
158         newProduct[pname].category = uCate;
159         newProduct[pname].pid = newpid;
160         newProduct[pname].price = uPrice;
161         listofproducts.push(pname) -1;
162     }
163 
164 
165 
166 
167 
168     function numberofProduct() view public returns (uint) {
169       return listofproducts.length;
170     }
171 
172     function getpnamefromid(uint _pid) view public returns (string memory){
173         return listofproducts[_pid];
174     }
175 
176 
177     function getProductFromName(string memory pname) view public returns (string memory, string memory,string memory, string memory, string memory, string memory, string memory) {
178 
179         if(newProduct[pname].time == 0){
180             return ("0", "0", "0","0","0","0","0");
181         } else {
182         return (uint2str(newProduct[pname].time), uint2str(newProduct[pname].price), newProduct[pname].headline, newProduct[pname].explain, newProduct[pname].imagelist, newProduct[pname].showdemo, newProduct[pname].category);
183         }
184     }
185 
186 
187     function checkProductExist(string memory pname) view public returns (bool) {
188 
189         if(newProduct[pname].time == 0){
190             return false;
191         } else {
192             return true;
193         }
194     }
195 
196 
197 
198 
199 
200   struct Requesters {
201       bool exists;
202       uint256 ptime;
203       string publicKey;
204       address rqaddress;
205   }
206 
207   mapping(string => Requesters[]) rlist;
208   mapping (string => bool) public RWlist;
209   string[] public listofrequests;
210 
211  function checkWalletexist(string memory _wallet) view public returns (bool){
212         return RWlist[_wallet];
213  }
214 
215 
216   function setNewRequest(string memory pname, string memory pubkey) public returns (uint)  {
217       bool checkProduct = checkProductExist(pname);
218       if(checkProduct){
219           string memory wid = appendString(WallettoString(msg.sender),pname);
220 
221           bool cwallet = checkWalletexist(wid);
222 
223           if(cwallet){
224               revert();
225           } else {
226             if(balanceOf[msg.sender] >= newProduct[pname].price) {
227               transfer(fundsWallet, newProduct[pname].price);
228               RWlist[wid]=true;
229               rlist[pname].push(Requesters(true,now, pubkey, msg.sender));
230               listofproducts.push(wid) -1;
231               return rlist[pname].length - 1;
232             } else {
233                 revert();
234             }
235 
236           }
237       } else {
238           revert();
239       }
240 
241   }
242 
243 
244 
245     function num_of_request() view public returns (uint) {
246       return listofproducts.length;
247     }
248 
249     function get_product_from_pid(uint _listid) view public returns (string memory){
250         return listofproducts[_listid];
251     }
252 
253 
254    function num_of_product_requests(string memory key) public view returns (uint) {
255     return rlist[key].length;
256   }
257 
258   function get_public_key(string memory key, uint index) public view returns (string memory) {
259     if (rlist[key][index].exists == false) {
260       assert(false);
261     }
262     return rlist[key][index].publicKey;
263   }
264 
265 
266    struct TransmitProduct {
267       bool exists;
268       bool status;
269       uint256 ptime;
270       string signedMessage;
271       address forwho;
272   }
273 
274   mapping(string => TransmitProduct[]) responseList;
275   mapping (string => bool) public BWlist;
276   string[] public listoftransmits;
277 
278 
279   function checkBWalletexist(string memory _walletandid) view public returns (bool){
280         return BWlist[_walletandid];
281   }
282 
283   function WallettoString(address x) public returns(string memory) {
284     bytes memory b = new bytes(20);
285     for (uint i = 0; i < 20; i++)
286         b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
287     return string(b);
288  }
289 
290  function appendString(string memory a, string memory b) internal pure returns (string memory) {
291     return string(abi.encodePacked(a, b));
292 }
293 
294 
295 
296    function setTransmitProduct(string memory pname, uint index, string memory smessage) payable public  {
297       bool checkProduct = checkProductExist(pname);
298       if(checkProduct){
299           address radress = rlist[pname][index].rqaddress;
300           string memory wid = appendString(WallettoString(radress),pname);
301           bool cwallet = checkBWalletexist(wid);
302 
303           if(cwallet){
304               //Buraya geliyorsa daha önce zaten göndermiş demektir.
305               revert();
306           } else {
307 
308               if(msg.sender == newProduct[pname].senderaddress){
309 
310                 require(balanceOf[fundsWallet] >= newProduct[pname].price);
311                 _transfer(fundsWallet, msg.sender, newProduct[pname].price);
312 
313                 BWlist[wid]=true;
314                 //Sadece alıcının çözüleceği şekilde istek şifrelenerek blockchaine yükleniyor.
315                 responseList[pname].push(TransmitProduct(true, true, now, smessage, radress));
316                 listoftransmits.push(wid) -1;
317               } else {
318                   revert();
319               }
320           }
321       } else {
322           revert();
323       }
324 
325   }
326 
327 
328 
329   function cancelTransmitProduct(string memory pname, uint index) public  {
330       bool checkProduct = checkProductExist(pname);
331       if(checkProduct){
332           address radress = rlist[pname][index].rqaddress;
333           string memory wid = appendString(WallettoString(radress),pname);
334           bool cwallet = checkBWalletexist(wid);
335 
336 
337           if(cwallet){
338               //Buraya geliyorsa daha önce zaten göndermiş demektir.
339               revert();
340           } else {
341               //Eğer önceden gönderim yapılmamışsa burası çalışır.
342               //rqaddress
343               if(msg.sender == rlist[pname][index].rqaddress){
344                 //Sadece o ürüne istek gönderen kişi iptal edebilir.
345 
346                 //coin kontrattan iptal edene iletiliyor.
347 
348                  require(balanceOf[fundsWallet] >= newProduct[pname].price);
349 
350                 _transfer(fundsWallet,msg.sender,newProduct[pname].price);
351 
352 
353                 BWlist[wid]=true;
354                 //status false olması ürünün iptal edildiği anlamına geliyor.
355                 //Gönderici parasını alıyor ve ürün
356                 responseList[pname].push(TransmitProduct(true, false, now, "canceled", radress));
357                 listoftransmits.push(wid) -1;
358               } else {
359                   revert();
360               }
361           }
362       } else {
363           revert();
364       }
365 
366   }
367 
368 
369     function num_of_transmit() view public returns (uint) {
370       return listoftransmits.length;
371     }
372 
373     function get_transmits_from_pid(uint _listid) view public returns (string memory){
374         return listoftransmits[_listid];
375     }
376 
377   function num_of_product_transmit(string memory _pid) public view returns (uint) {
378     return responseList[_pid].length;
379   }
380 
381   function getTransmits(string memory _pid, uint index) public view returns (address) {
382     if (responseList[_pid][index].exists == false) {
383       assert(false);
384     }
385     return rlist[_pid][index].rqaddress;
386   }
387 
388 
389 
390     function() payable external{
391       uint256 yirmimart = 1553040000;
392       uint256 onnisan = 1554854400;
393       uint256 birmayis = 1556668800;
394       uint256 yirmimayis = 1558310400;
395       uint256 onhaziran = 1560124800;
396 
397       if(yirmimart > now) {
398         require(balanceOf[fundsWallet] >= msg.value * 100);
399         _transfer(fundsWallet, msg.sender, msg.value * 100);
400         fundsWallet.transfer(msg.value);
401       } else if(yirmimart < now && onnisan > now) {
402         require(balanceOf[fundsWallet] >= msg.value * 15000);
403         _transfer(fundsWallet, msg.sender, msg.value * 15000);
404         fundsWallet.transfer(msg.value);
405       } else if(onnisan < now && birmayis > now) {
406         require(balanceOf[fundsWallet] >= msg.value * 12000);
407         _transfer(fundsWallet, msg.sender, msg.value * 12000);
408         fundsWallet.transfer(msg.value);
409       }else if(birmayis < now && yirmimayis > now) {
410         require(balanceOf[fundsWallet] >= msg.value * 10000);
411         _transfer(fundsWallet, msg.sender, msg.value * 10000);
412         fundsWallet.transfer(msg.value);
413       }else if(yirmimayis < now && onhaziran > now) {
414         require(balanceOf[fundsWallet] >= msg.value * 7500);
415         _transfer(fundsWallet, msg.sender, msg.value * 7500);
416         fundsWallet.transfer(msg.value);
417       } else {
418         assert(false);
419       }
420 
421     }
422 
423 }