1 pragma solidity 0.5.9;
2 
3 library SafeMath {
4 
5     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6         require(b <= a, "SafeMath: subtraction overflow");
7         uint256 c = a - b;
8 
9         return c;
10     }
11 
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18 }
19 
20 contract HotelierCoin {
21     
22     using SafeMath for uint256;
23 
24     string private _name;
25     string private _symbol;
26     uint256 private _totalSupply;
27     address private _owner;
28     uint8 private _decimals;
29     bool private _isReserveEnabled;
30     
31     /**
32     
33     * All code definitions below
34     
35     */    
36     
37     uint8 private _code_for_department_of_team = 100; //23 mil
38     uint8 private _code_for_department_of_foundation_community_building = 103; //3 mil
39     uint8 private _code_for_department_of_advisor = 104; //4 mil
40     uint8 private _code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop = 101; //70mil
41     uint8 private _code_for_reserve_account = 102; //50 mil
42     
43     uint8 private _code_for_reserve_private_sales = 105; // 2.5 mil
44     
45     //5 percent of reserve/ private sales
46     //new mint events: 3 percent goes to team(1.5 mil), 7 percent goes to community and rewards(3.5 mil),  90 percent to reserve(45 mil)
47     
48     
49      /**
50     
51     * All mappings below
52     
53     */
54     mapping (address => uint256) private _balances;
55     mapping(uint8 => address) private _departmentInfo;
56     mapping(address => uint8) private _departmentCodeInfo;
57     mapping (address => mapping (address => uint256)) private _allowances;
58     
59     /**
60     
61     * All events below
62     
63     */
64     
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68     
69     event MintOccured(uint256 totalCoins, address source);
70     
71     event ChangeOfDepartment(address oldAddy, address newlyAssignedAddy);
72     
73     event ReserveEnabled();
74     
75     /**
76      
77     * Constructor to initialize important values 
78     
79     */
80         
81     constructor () public {
82         _name = "HotelierCoin";
83         _symbol = "HTLC";
84         _decimals = 8;
85         _totalSupply = 15000000000000000;
86         _balances[msg.sender] = _totalSupply;
87         _owner = msg.sender;
88         _isReserveEnabled = false;
89     }
90     
91     modifier onlyOwner() {
92         require(msg.sender == _owner,"ONLY AN OWNER CAN CALL THIS FUNCTION");
93         _;
94     }
95     
96     /**
97     
98      *  return contract creator/admin.
99     
100      */
101      
102     function contractCreator() public view returns(address){
103         return _owner;
104     }
105 
106     /**
107     
108      *  the name of the token.
109     
110      */
111      
112     function name() public view returns (string memory) {
113         return _name;
114     }
115 
116     /**
117     
118      *  the symbol of the token.
119     
120      */
121      
122     function symbol() public view returns (string memory) {
123         return _symbol;
124     }
125     
126     /**
127      
128      * returns the decimals
129      
130      **/
131      
132      function decimals() public view returns(uint8 decimalCount){
133          return _decimals;
134      }
135     
136     /**
137      
138      *  total HTL token supply.
139      
140      */
141      
142     function totalSupply() external view returns(uint256){
143         return _totalSupply;
144     }
145     
146     /**
147      
148      * return the HTL balance of the address passed as a parameter.
149      
150      */
151      
152     function balanceOf(address owner) external view returns (uint256) {
153         return _balances[owner];
154     }
155     
156     /**
157      
158      * return codes for various departments
159      
160      */
161      
162      function departmentCodeInfo(address departmentAddress) public view returns(uint8){
163          require(_departmentCodeInfo[departmentAddress] != 0, "ADDRESS IS NOT IN USE IN ANY DEPARTMENT");
164          return _departmentCodeInfo[departmentAddress];
165      }
166     
167     
168     /**
169      
170      * return the department address currently being allowed
171      
172      */
173      
174     function departmentInfo(uint8 departmentCode) public view returns(address){
175          require(_departmentInfo[departmentCode] != address(0), "NO ADDRESS EXISTS");
176         return _departmentInfo[departmentCode];
177     }    
178     
179     /**
180      
181      * retun allowance value for anyone.
182      
183      */
184      
185     function allowance(address owner, address spender) external view returns (uint256) {
186         return _allowances[owner][spender];
187     }
188     
189     function changeDepartmentAddress( address _addr, uint8 _departmentCode ) public onlyOwner returns (bool){
190         
191         require(_departmentInfo[_departmentCode] != address(0), "NO ZERO ADDRESS CAN BE MADE DEPARTMENT ADDRESS");
192         
193         for(uint8 i=100;i<106;i++){
194             require(_departmentInfo[i] != _addr, "NO TWO DEPARTMENTS CAN HAVE THE SAME ADDRESS");
195         }
196         
197         uint256 _balanceToApprove = _balances[_departmentInfo[_departmentCode]];
198         _balances[_departmentInfo[_departmentCode]] = _balances[_departmentInfo[_departmentCode]].sub(_balanceToApprove);
199         _balances[_addr] = _balances[_addr].add(_balanceToApprove);
200         
201         _allowances[_addr][msg.sender] = _balances[_addr];
202         
203         emit ChangeOfDepartment(_departmentInfo[_departmentCode], _addr);
204         emit Approval(_addr,msg.sender,_balanceToApprove);
205         emit Transfer(_departmentInfo[_departmentCode], _addr, _balances[_departmentInfo[_departmentCode]]);
206         
207         _departmentInfo[_departmentCode] = _addr;
208         _departmentCodeInfo[_addr] = _departmentCode;
209         return true;
210         
211     }
212     
213     function mint() public onlyOwner returns(bool){
214         
215         require(_balances[_departmentInfo[_code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop]] < 1000,"CONDITIONS NOT MET FOR MINTING");
216         
217         address team = _departmentInfo[_code_for_department_of_team];
218         uint256 teamShare = 150000000000000;
219         
220         address communityBuilding = _departmentInfo[_code_for_department_of_foundation_community_building];
221         uint256 communityBuildingShare = 350000000000000;
222         
223         address reserve = _departmentInfo[_code_for_reserve_account];
224         require(_balances[reserve] < 500000000000000, "MINTING NOT POSSIBLE");
225         uint256 reserveShare = 4500000000000000;
226         
227         
228         require(team != address(0), "FORBIDDEN!:: MINT");
229         require(communityBuilding != address(0), "FORBIDDEN!:: MINT");
230         require(reserve != address(0), "FORBIDDEN!:: MINT");
231         
232         require(teamShare + communityBuildingShare + reserveShare == 5000000000000000, "MINTING VALUE ERROR!" );
233 
234         _mint(team,communityBuilding, reserve, teamShare, communityBuildingShare, reserveShare);
235         return true;
236         
237     }
238 
239     function transfer(address to, uint256 value) external returns (bool) {
240         
241         _transfer(msg.sender, to, value);
242         return true;
243         
244     }
245     
246     /**
247      
248      * 50 mil 
249      
250      */
251     
252     function setReserve(address reserve) external onlyOwner returns(bool){
253         require(_departmentInfo[_code_for_reserve_account] == address(0));
254         require(_departmentInfo[_code_for_reserve_private_sales] != reserve, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
255         require(_departmentInfo[_code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop] != reserve, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
256         require(_departmentInfo[_code_for_department_of_advisor] != reserve, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
257         require(_departmentInfo[_code_for_department_of_foundation_community_building] != reserve, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
258         require(_departmentInfo[_code_for_department_of_team] != reserve, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
259         require(reserve != address(0));
260         _departmentInfo[_code_for_reserve_account] =reserve;
261         _departmentCodeInfo[reserve] = _code_for_reserve_account;
262         _transfer(msg.sender, reserve, 5000000000000000);
263         _approve(reserve,_owner, 5000000000000000);
264         return true;
265         
266     }
267     
268     /**
269      
270      * 23 mil / 30 mil 
271      
272      */
273      
274     function setTeam(address team) external onlyOwner returns(bool){
275         require(_departmentInfo[_code_for_department_of_team] == address(0));
276         require(_departmentInfo[_code_for_reserve_private_sales] != team, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
277         require(_departmentInfo[_code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop] != team, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
278         require(_departmentInfo[_code_for_department_of_advisor] != team, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
279         require(_departmentInfo[_code_for_department_of_foundation_community_building] != team, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
280         require(_departmentInfo[_code_for_reserve_account] != team, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
281         require(team != address(0));
282         _departmentInfo[_code_for_department_of_team] =team;
283         _departmentCodeInfo[team] = _code_for_department_of_team;
284         _transfer(msg.sender, team, 2300000000000000);
285         _approve(team,_owner, 2300000000000000);
286         return true;
287         
288     }
289     
290     /**
291      
292      * 3 mil / 30 mil
293      
294      */
295      
296     function setFoundationCommunityBuilding(address community) external onlyOwner returns(bool){
297         require(_departmentInfo[_code_for_department_of_foundation_community_building] == address(0));
298         require(_departmentInfo[_code_for_reserve_private_sales] != community, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
299         require(_departmentInfo[_code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop] != community, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
300         require(_departmentInfo[_code_for_department_of_advisor] != community, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
301         require(_departmentInfo[_code_for_department_of_team] != community, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
302         require(_departmentInfo[_code_for_reserve_account] != community, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
303         require(community != address(0));
304         _departmentInfo[_code_for_department_of_foundation_community_building] =community;
305         _departmentCodeInfo[community] = _code_for_department_of_foundation_community_building;
306         _transfer(msg.sender, community, 300000000000000);
307         _approve(community,_owner, 300000000000000);
308         return true;
309         
310     }
311     
312     /**
313      
314      * 4 mil / 30 mil 
315      
316      */
317     
318     function setAdvisor(address advisor) external onlyOwner returns(bool){
319         require(_departmentInfo[_code_for_department_of_advisor] == address(0));
320         require(_departmentInfo[_code_for_reserve_private_sales] != advisor, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
321         require(_departmentInfo[_code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop] != advisor, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
322         require(_departmentInfo[_code_for_department_of_foundation_community_building] != advisor, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
323         require(_departmentInfo[_code_for_department_of_team] != advisor, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
324         require(_departmentInfo[_code_for_reserve_account] != advisor, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
325         require(advisor != address(0));
326         _departmentInfo[_code_for_department_of_advisor] =advisor;
327         _departmentCodeInfo[advisor] = _code_for_department_of_advisor;
328         _transfer(msg.sender, advisor, 400000000000000);
329         _approve(advisor,_owner, 400000000000000);
330         return true;
331         
332     }
333     
334     /**
335      
336      * 70 mil/ 70 mil 
337      
338      */
339     
340     function setCashbackSalesIeoRewardsAirdrop(address cashback) external onlyOwner returns(bool){
341         require(_departmentInfo[_code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop] == address(0));
342         require(_departmentInfo[_code_for_reserve_private_sales] != cashback, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
343         require(_departmentInfo[_code_for_department_of_advisor] != cashback, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
344         require(_departmentInfo[_code_for_department_of_foundation_community_building] != cashback, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
345         require(_departmentInfo[_code_for_department_of_team] != cashback, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
346         require(_departmentInfo[_code_for_reserve_account] != cashback, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
347         require(cashback != address(0));
348         _departmentInfo[_code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop] =cashback;
349         _departmentCodeInfo[cashback] = _code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop;
350         _transfer(msg.sender, cashback, 7000000000000000);
351         _approve(cashback,_owner, 7000000000000000);
352         return true;
353         
354     }
355     
356     /**
357      
358      * 2.5 mil /50 mil (reserve) 
359      
360      */
361      
362     function setPrivateSalesFromReserve(address privateSales) external onlyOwner returns(bool){
363         
364         require(_departmentInfo[_code_for_reserve_private_sales] == address(0));
365         require(_departmentInfo[_code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop] != privateSales, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
366         require(_departmentInfo[_code_for_department_of_advisor] != privateSales, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
367         require(_departmentInfo[_code_for_department_of_foundation_community_building] != privateSales, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
368         require(_departmentInfo[_code_for_department_of_team] != privateSales, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
369         require(_departmentInfo[_code_for_reserve_account] != privateSales, "ADDRESS ALREADY EXISTS FOR OTHER DEPARTMENT");
370         require(privateSales != address(0));
371         require(_allowances[_departmentInfo[_code_for_reserve_account]][msg.sender]  > 0, "RESERVE ADDRESS MUST EXIST AND SET");
372         _departmentInfo[_code_for_reserve_private_sales] = privateSales;
373         _departmentCodeInfo[privateSales] = _code_for_reserve_private_sales;
374         _transfer(_departmentInfo[_code_for_reserve_account], privateSales, 250000000000000);
375         _approve(privateSales,_owner, 250000000000000);
376         return true;
377         
378     }
379     
380 
381     function transferFrom(address from, address to ,uint256 value) external returns (bool) {
382         
383         require(_allowances[from][msg.sender] > value , "NOT ENOUGH ALLOWANCE VALUE TO SPEND");
384         _transfer(from, to, value);
385         _approve(from, msg.sender,_allowances[from][msg.sender].sub(value));
386         return true;
387         
388     }
389 
390     function _transfer(address from, address to, uint256 _value) internal {
391         
392         require(from != address(0));
393         require(to != address(0));
394         if(_departmentInfo[_code_for_reserve_account] == from){
395             require(_isReserveEnabled == true, "RESERVE CANT BE USED");
396         }
397         
398             _balances[from] = _balances[from].sub(_value);
399             _balances[to] = _balances[to].add(_value);
400             
401      
402             emit Transfer(from, to, _value);
403         
404         
405     }
406     
407      function enableReserveTransfers() external onlyOwner returns(bool){
408          require(_departmentInfo[_code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop] != address(0));
409          require(_balances[_departmentInfo[_code_for_department_of_cashback_sales_ieo_p2p_rewards_airdrop]] <1000);
410             _isReserveEnabled = true;
411             emit ReserveEnabled();
412     }
413 
414     function _mint(address team, address communityBuilding, address reserve, uint256 teamShare, uint256 communityBuildingShare, uint256 reserveShare) internal {
415         uint256 totalMintedCoins = teamShare + communityBuildingShare + reserveShare;
416         _totalSupply = _totalSupply.add(totalMintedCoins);
417         
418         _balances[team] = _balances[team].add(teamShare);
419         _balances[communityBuilding] = _balances[communityBuilding].add(communityBuildingShare);
420         _balances[reserve] = _balances[reserve].add(reserveShare);
421         
422         _allowances[team][_owner] = _allowances[team][_owner].add(teamShare);
423         _allowances[communityBuilding][_owner] = _allowances[communityBuilding][_owner].add(communityBuildingShare);
424         _allowances[reserve][_owner] = _allowances[reserve][_owner].add(reserveShare);
425         
426         emit Approval(team,_owner,teamShare);
427         emit Approval(communityBuilding,_owner,communityBuildingShare);
428         emit Approval(reserve,_owner,reserveShare);
429         
430         emit Transfer(address(0), team, teamShare);
431         emit Transfer(address(0), communityBuilding, communityBuildingShare);
432         emit Transfer(address(0), reserve, reserveShare);
433         
434         emit MintOccured(totalMintedCoins, msg.sender);
435     }
436 
437 
438     function _approve(address owner, address spender, uint256 value) internal {
439         require(owner != address(0));
440         require(spender != address(0));
441         _allowances[owner][spender] = value;
442         emit Approval(owner, spender, value);
443     }
444 
445 }