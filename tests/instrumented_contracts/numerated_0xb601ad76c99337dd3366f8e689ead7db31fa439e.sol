1 /*
2 Copyright (C) 2017-2018 Hashfuture Inc. All rights reserved.
3 This document is the property of Hashfuture Inc.
4 */
5 
6 pragma solidity ^0.4.24;
7 
8 library SafeMath {
9 
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         assert(c >= a);
18         return c;
19     }
20 }
21 
22 contract HashFutureBasicToken {
23 
24     using SafeMath for uint256;
25 
26     // Mapping from token ID to owner
27     mapping (uint256 => address) internal tokenOwner;
28 
29     // Mapping from owner to number of owned token
30     mapping (address => uint256) internal ownedTokensCount;
31 
32     modifier onlyOwnerOf(uint256 _tokenId) {
33         require(tokenOwner[_tokenId] == msg.sender);
34         _;
35     }
36 
37     function balanceOf(address _owner) public view returns (uint256) {
38         return ownedTokensCount[_owner];
39     }
40 
41     function ownerOf(uint256 _tokenId) public view returns (address) {
42         address owner = tokenOwner[_tokenId];
43         return owner;
44     }
45 
46     function addTokenTo(address _to, uint256 _tokenId) internal {
47         require(tokenOwner[_tokenId] == address(0));
48         tokenOwner[_tokenId] = _to;
49         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
50     }
51 
52     function removeTokenFrom(address _from, uint256 _tokenId) internal {
53         require(ownerOf(_tokenId) == _from);
54         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
55         tokenOwner[_tokenId] = address(0);
56     }
57 
58     function _mint(address _to, uint256 _tokenId) internal {
59         require(_to != address(0));
60         addTokenTo(_to, _tokenId);
61     }
62 
63     function _burn(address _owner, uint256 _tokenId) internal {
64         removeTokenFrom(_owner, _tokenId);
65     }
66 }
67 
68 
69 contract HashFutureToken is HashFutureBasicToken{
70 
71     string internal name_;
72     string internal symbol_;
73 
74     address public owner;
75 
76     // Array with all token ids, used for enumeration
77     uint256[] internal allTokens;
78 
79     // Mapping from token id to position in the allTokens array
80     mapping(uint256 => uint256) internal allTokensIndex;
81 
82     // Mapping from owner to list of owned token IDs
83     mapping (address => uint256[]) internal ownedTokens;
84 
85     // Mapping from token ID to index of the owner tokens list
86     mapping(uint256 => uint256) internal ownedTokensIndex;
87 
88     modifier onlyOwner {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     constructor(string _name, string _symbol) public {
94         name_ = _name;
95         symbol_ = _symbol;
96         owner = msg.sender;
97     }
98 
99 
100     function transferOwnership(address newOwner) onlyOwner public {
101         owner = newOwner;
102     }
103 
104     function name() external view returns (string) {
105         return name_;
106     }
107 
108     function symbol() external view returns (string) {
109         return symbol_;
110     }
111 
112     function totalSupply() external view returns (uint256) {
113         return allTokens.length;
114     }
115 
116     function tokenByIndex(uint256 _index) external view returns (uint256) {
117         require(_index < allTokens.length);
118         return allTokens[_index];
119     }
120 
121     function tokenOfOwnerByIndex(
122         address _owner,
123         uint256 _index
124     )
125         external view returns (uint256)
126     {
127         require(_index < balanceOf(_owner));
128         return ownedTokens[_owner][_index];
129     }
130 
131     function addTokenTo(address _to, uint256 _tokenId) internal {
132         super.addTokenTo(_to, _tokenId);
133 
134         uint256 length = ownedTokens[_to].length;
135         ownedTokens[_to].push(_tokenId);
136         ownedTokensIndex[_tokenId] = length;
137     }
138 
139     function removeTokenFrom(address _from, uint256 _tokenId) internal {
140         super.removeTokenFrom(_from, _tokenId);
141 
142         uint256 tokenIndex = ownedTokensIndex[_tokenId];
143         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
144         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
145 
146         ownedTokens[_from][tokenIndex] = lastToken;
147         ownedTokens[_from][lastTokenIndex] = 0;
148 
149         ownedTokens[_from].length = ownedTokens[_from].length.sub(1);
150         ownedTokensIndex[_tokenId] = 0;
151         ownedTokensIndex[lastToken] = tokenIndex;
152     }
153 
154     function _mint(address _to, uint256 _tokenId) internal {
155         super._mint(_to, _tokenId);
156 
157         allTokensIndex[_tokenId] = allTokens.length;
158         allTokens.push(_tokenId);
159     }
160 
161     function _burn(address _owner, uint256 _tokenId) internal {
162         super._burn(_owner, _tokenId);
163 
164         uint256 tokenIndex = allTokensIndex[_tokenId];
165         uint256 lastTokenIndex = allTokens.length.sub(1);
166         uint256 lastToken = allTokens[lastTokenIndex];
167 
168         allTokens[tokenIndex] = lastToken;
169         allTokens[lastTokenIndex] = 0;
170 
171         allTokens.length = allTokens.length.sub(1);
172         allTokensIndex[_tokenId] = 0;
173         allTokensIndex[lastToken] = tokenIndex;
174     }
175 }
176 
177 
178 /**
179  * Official token issued by HashFuture Inc.
180  * This is the token for inverstors and close partners.
181  */
182 contract InvestorToken is HashFutureToken{
183 
184     string internal privilege;
185     string internal contractIntroduction;
186 
187     constructor() HashFutureToken("HashFuture InvestorToken", "HFIT") public
188     {
189         privilege = "1.Free service: Token holders enjoy free service of asset tokenization on HashFuture platform; 2.Preemptive right: Token holders have the preemptive right of buying HashFuture digital asset, namely, the priority to buy asset compare to normal users; 3.Transaction fee discount: Token holders enjoy 50% discount on transaction fee on HashFuture platform;";
190         contractIntroduction = "1. This token cannot be transferred, only investor himself or herself can hold the token and enjoy the privileges; 2. The privileges of this token will be upgraded with deeper cooperation with investors and the development of HashFuture;3. If the investor quits from the HashFuture platform, this token and its privileges will be destroyed as well;";
191     }
192 
193     struct IdentityInfo {
194         string hashID;
195         string name;
196         string country;
197         string photoUrl;
198         string institute;
199         string occupation;
200         string suggestions;
201     }
202 
203     mapping(uint256 => IdentityInfo) IdentityInfoOfId;
204 
205      /**
206       * @param _hashID token holder customized field, the HashFuture account ID
207       * @param _name token holder customized field, the name of the holder
208       * @param _country token holder customized field.
209       * @param _photoUrl token holder customized field, link to holder's photo
210       * @param _institute token holder customized field, institute the holder works for
211       * @param _occupation token holder customized field, holder's occupation in the institute he/she works in
212       * @param _suggestions token holder customized field, holder's suggestions for HashFuture
213       **/
214     function issueToken(
215         address _to,
216         string _hashID,
217         string _name,
218         string _country,
219         string _photoUrl,
220         string _institute,
221         string _occupation,
222         string _suggestions
223     )
224         public onlyOwner
225     {
226         uint256 _tokenId = allTokens.length;
227 
228         IdentityInfoOfId[_tokenId] = IdentityInfo(
229             _hashID, _name, _country, _photoUrl,
230             _institute, _occupation, _suggestions
231         );
232 
233         _mint(_to, _tokenId);
234     }
235 
236     /**
237      * @dev the contract owner can burn (recycle) any token in circulation.
238      **/
239     function burnToken(uint256 _tokenId) public onlyOwner{
240         address tokenOwner = ownerOf(_tokenId);
241         require(tokenOwner != address(0));
242 
243         delete IdentityInfoOfId[_tokenId];
244         _burn(tokenOwner, _tokenId);
245     }
246 
247     /**
248      * @dev Get the holder's info of a token.
249      * @param _tokenId id of interested token
250      **/
251     function getTokenInfo(uint256 _tokenId)
252         external view
253         returns (string, string, string, string, string, string, string)
254     {
255         address tokenOwner = ownerOf(_tokenId);
256         require(tokenOwner != address(0));
257 
258         IdentityInfo storage pInfo = IdentityInfoOfId[_tokenId];
259         return (
260             pInfo.hashID,
261             pInfo.name,
262             pInfo.country,
263             pInfo.photoUrl,
264             pInfo.institute,
265             pInfo.occupation,
266             pInfo.suggestions
267         );
268     }
269 
270     /**
271      * @dev Set holder's IdentityInfo of a token
272      * @param _tokenId id of target token.
273      * @param _name token holder customized field, the name of the holder
274      * @param _country token holder customized field.
275      * @param _photoUrl token holder customized field, link to holder's photo
276      * @param _institute token holder customized field, institute the holder works for
277      * @param _occupation token holder customized field, holder's occupation in the institute he/she works in
278      * @param _suggestions token holder customized field, holder's suggestions for HashFuture
279      **/
280     function setIdentityInfo(
281         uint256 _tokenId,
282         string _name,
283         string _country,
284         string _photoUrl,
285         string _institute,
286         string _occupation,
287         string _suggestions
288     )
289         public
290         onlyOwnerOf(_tokenId)
291     {
292         IdentityInfo storage pInfo = IdentityInfoOfId[_tokenId];
293 
294         pInfo.name = _name;
295         pInfo.country = _country;
296         pInfo.photoUrl = _photoUrl;
297         pInfo.institute = _institute;
298         pInfo.occupation = _occupation;
299         pInfo.suggestions = _suggestions;
300     }
301 
302     /**
303      * @dev Set suggestions for Hashfuture
304      * only holder of a token can use this function
305      */
306     function setSuggestion(
307         uint256 _tokenId,
308         string _suggestions
309     )
310         public
311         onlyOwnerOf(_tokenId)
312     {
313         IdentityInfoOfId[_tokenId].suggestions = _suggestions;
314     }
315 
316     /**
317      * @dev Get privilege of the token
318      **/
319     function getPrivilege() external view returns (string) {
320         return privilege;
321     }
322 
323     /**
324      * @dev Get the introduction of the token
325      **/
326     function getContractIntroduction() external view returns (string) {
327         return contractIntroduction;
328     }
329 
330     /**
331      * @dev Update token holder's privileges
332      * only official operator can use this function
333      **/
334     function updatePrivilege(string _privilege) public onlyOwner {
335         privilege = _privilege;
336     }
337 }