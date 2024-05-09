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
176 /**
177  * Official token issued by HashFuture Inc.
178  * This is the token for HashFuture pioneers.
179  */
180 contract CommunityToken is HashFutureToken{
181 
182     string internal privilege;
183     string internal contractIntroduction;
184 
185     constructor() HashFutureToken("HashFuture CommunityToken", "HFCT") public {
186         privilege = "1.Privilege of enjoying a monthly airdrop of 10 Antarctic Lands; 2.Privilege of enjoying higher priority in pre-sale shares of tokenized assets in HashFuture trading platform; 3.Privilege of 20% discount in the commission fee of trading in HashFuture trading platform;";
187         contractIntroduction = "1. This token cannot be transferred, only the holder himself or herself can hold the token and enjoy the privileges; 2. The privileges of this token will be upgraded with the development of HashFuture; 3. If the holder quits from the HashFuture platform, this token and its privileges will be destroyed as well;";
188     }
189 
190     struct IdentityInfo {
191         string hashID;
192         string name;
193         string country;
194     }
195 
196     mapping(uint256 => IdentityInfo) IdentityInfoOfId;
197 
198     /**
199      * @param _hashID token holder customized field, the HashFuture account ID
200      * @param _name token holder customized field, the name of the holder
201      * @param _country token holder customized field.
202      **/
203     function issueToken(
204         address _to,
205         string _hashID,
206         string _name,
207         string _country
208     )
209         public onlyOwner
210     {
211         uint256 _tokenId = allTokens.length;
212 
213         IdentityInfoOfId[_tokenId] = IdentityInfo(
214             _hashID, _name, _country
215         );
216 
217         _mint(_to, _tokenId);
218     }
219 
220     /**
221      * @dev the contract owner can burn (recycle) any token in circulation.
222      **/
223     function burnToken(uint256 _tokenId) public onlyOwner{
224         address tokenOwner = ownerOf(_tokenId);
225         require(tokenOwner != address(0));
226 
227         delete IdentityInfoOfId[_tokenId];
228         _burn(tokenOwner, _tokenId);
229     }
230 
231     /**
232      * @dev Get the holder's info of a token.
233      * @param _tokenId id of interested token
234      **/
235     function getTokenInfo(uint256 _tokenId) external view returns (string, string, string) {
236         address tokenOwner = ownerOf(_tokenId);
237         require(tokenOwner != address(0));
238 
239         IdentityInfo storage pInfo = IdentityInfoOfId[_tokenId];
240         return (
241             pInfo.hashID,
242             pInfo.name,
243             pInfo.country
244         );
245     }
246 
247     /**
248      * @dev Get the privilege of the token
249      **/
250     function getPrivilege() external view returns (string) {
251         return privilege;
252     }
253 
254     /**
255      * @dev Get the introduction of the token
256      **/
257     function getContractIntroduction() external view returns (string) {
258         return contractIntroduction;
259     }
260 
261     /**
262      * @dev Update token holder's privileges
263      * only official operator can use this function
264      **/
265     function updatePrivilege(string _privilege) public onlyOwner {
266         privilege = _privilege;
267     }
268 
269 }