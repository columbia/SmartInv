1 pragma solidity ^0.4.24;
2 
3 
4 interface App 
5 {
6     function mint(address receiver, uint64 wad) external returns (bool);
7     function changeGatewayAddr(address newer) external returns (bool);
8 }
9 
10 contract GatewayVote 
11 {
12     
13     struct Vote 
14     {
15         bool done;
16         uint poll;
17         mapping(uint256 => uint8) voters;
18     }
19     
20     struct AppInfo
21     {
22         uint32 chainCode;
23         uint32 tokenCode;
24         uint256 app;
25     }
26 
27 
28     // FIELDS
29     bool    public mStopped;
30     uint32  public mMaxAppCode;
31     uint32  public mMaxChainCode;
32     uint256 public mNumVoters;
33     
34     mapping(uint256 => uint8) mVoters;
35     mapping(uint256 => Vote) mVotesStore;
36     
37     mapping(uint256 => uint32) mAppToCode;
38     mapping(uint32 => AppInfo) mCodeToAppInfo;
39     
40     mapping(string => uint32) mChainToCode;
41     mapping(uint32 => string) mCodeToChain;
42     
43 
44     // EVENTS
45     event Stopped(uint256 indexed operation);
46     event Started(uint256 indexed operation);
47     
48     event Confirmation(address voter, uint256 indexed operation);
49     event OperationDone(address voter, uint256 indexed operation);
50     event Revoke(address revoker, uint256 indexed operation);
51     
52     event VoterChanged(address oldVoter, address newVoter, uint256 indexed operation);
53     event VoterAdded(address newVoter, uint256 indexed operation);
54     event VoterRemoved(address oldVoter, uint256 indexed operation);
55     
56     event ChainAdded(string chain, uint256 indexed operation);
57     
58     event AppAdded(address app, uint32 chain, uint32 token, uint256 indexed operation);
59     event AppRemoved(uint32 code, uint256 indexed operation);
60     
61     event MintByGateway(uint32 appCode, address receiver, uint64 wad, uint256 indexed operation);
62     event BurnForGateway(uint32 appCode, address from, string receiver, uint64 wad);
63 
64     event GatewayAddrChanged(uint32 appCode, address newer, uint256 indexed operation);
65 
66     // METHODS
67 
68     constructor(address[] voters) public 
69     {
70         mNumVoters = voters.length;
71         for (uint i = 0; i < voters.length; ++i)
72         {
73             mVoters[uint(voters[i])] = 1;
74         }
75     }
76     
77     function isVoter(address voter) public view returns (bool) 
78     {
79         return mVoters[uint(voter)] == 1;
80     }
81     
82     function isApper(address app) public view returns (bool) 
83     {
84         return mAppToCode[uint(app)] > 0;
85     }
86     
87     function isAppCode(uint32 code) public view returns (bool) 
88     {
89         return mAppToCode[uint256(mCodeToAppInfo[code].app)] == code;
90     }
91     
92     function getAppAddress(uint32 code) public view returns (address) 
93     {
94         return address(mCodeToAppInfo[code].app);
95     }
96     
97     function getAppChainCode(uint32 code) public view returns (uint32) 
98     {
99         return mCodeToAppInfo[code].chainCode;
100     }
101     
102     function getAppTokenCode(uint32 code) public view returns (uint32)
103     {
104         return mCodeToAppInfo[code].tokenCode;
105     }
106     
107     function getAppInfo(uint32 code) public view returns (address, uint32, uint32)
108     {
109         return (address(mCodeToAppInfo[code].app), mCodeToAppInfo[code].chainCode, mCodeToAppInfo[code].tokenCode);
110     }
111     
112     function getAppCode(address app) public view returns (uint32) 
113     {
114         return mAppToCode[uint256(app)];
115     }
116     
117     function isCaller(address addr) public view returns (bool) 
118     {
119         return isVoter(addr) || isApper(addr);
120     }
121     
122     function isChain(string chain) public view returns (bool) 
123     {
124         return mChainToCode[chain] > 0;
125     }
126     
127     function isChainCode(uint32 code) public view returns (bool)
128     {
129         return mChainToCode[mCodeToChain[code]] == code;
130     }
131     
132     function getChainName(uint32 code) public view returns (string) 
133     {
134         return mCodeToChain[code];
135     }
136     
137     function getChainCode(string chain) public view returns (uint32) 
138     {
139         return mChainToCode[chain];
140     }
141     
142     function hasConfirmed(uint256 operation, address voter) public constant returns (bool) 
143     {
144         if (mVotesStore[operation].voters[uint(voter)] == 1) 
145         {
146             return true;
147         } 
148         else 
149         {
150             return false;
151         }
152     }
153     
154     function major(uint total) internal pure returns (uint r) 
155     {
156         r = (total * 2 + 1);
157         return r%3==0 ? r/3 : r/3+1;
158     }
159 
160     function confirmation(uint256 operation) internal returns (bool) 
161     {
162         Vote storage vote = mVotesStore[operation];
163         
164         if (vote.done) return;
165         
166         if (vote.voters[uint(tx.origin)] == 0) 
167         {
168             vote.voters[uint(tx.origin)] = 1;
169             vote.poll++;
170             emit Confirmation(tx.origin, operation);
171         }
172         
173         //check if poll is enough to go ahead.
174         if (vote.poll >= major(mNumVoters)) 
175         {
176             vote.done = true;
177             emit OperationDone(tx.origin, operation);
178             return true;
179         }
180     }
181     
182     function stop(string proposal) external 
183     {
184         // the origin tranx sender should be a voter
185         // contract should be running
186         require(isVoter(tx.origin) && !mStopped);
187         
188         // wait for voters until poll >= major
189         if(!confirmation(uint256(keccak256(msg.data)))) return;
190         
191         // change state
192         mStopped = true;
193         
194         // log output
195         emit Stopped(uint(keccak256(msg.data)));
196     }
197     
198     function start(string proposal) external 
199     {
200         
201         // the origin tranx sender should be a voter
202         // contract should be stopped
203         require(isVoter(tx.origin) && mStopped);
204         
205         if(!confirmation(uint256(keccak256(msg.data)))) return;
206         
207         mStopped = false;
208         
209         emit Started(uint(keccak256(msg.data)));
210     }
211     
212     function revoke(uint256 operation) external 
213     {
214         
215         require(isVoter(tx.origin) && !mStopped);
216         
217         Vote storage vote = mVotesStore[operation];
218         
219         // the vote for this operation should not be done
220         // the origin tranx sender should have voted to this operation
221         require(!vote.done && (vote.voters[uint(tx.origin)] ==  1));
222         
223         vote.poll--;
224         delete vote.voters[uint(tx.origin)];
225         
226         emit Revoke(tx.origin, operation);
227     }
228     
229     function changeVoter(address older, address newer, string proposal) external 
230     {
231         
232         require(isVoter(tx.origin) && !mStopped && isVoter(older) && !isVoter(newer));
233         
234         if(!confirmation(uint256(keccak256(msg.data)))) return;
235         
236         mVoters[uint(newer)] = 1;
237         delete mVoters[uint(older)];
238         
239         emit VoterChanged(older, newer, uint(keccak256(msg.data)));
240     }
241     
242     function addVoter(address newer, string proposal) external 
243     {
244         
245         require(isVoter(tx.origin) && !mStopped && !isVoter(newer));
246         
247         if(!confirmation(uint256(keccak256(msg.data)))) return;
248         
249         mNumVoters++;
250         mVoters[uint(newer)] = 1;
251         
252         emit VoterAdded(newer, uint256(keccak256(msg.data)));
253     }
254     
255     function removeVoter(address older, string proposal) external 
256     {
257         
258         require(isVoter(tx.origin) && !mStopped && isVoter(older));
259         
260         if(!confirmation(uint256(keccak256(msg.data)))) return;
261         
262         mNumVoters--;
263         delete mVoters[uint(older)];
264         
265         emit VoterRemoved(older, uint256(keccak256(msg.data)));
266     }
267     
268     function addChain(string chain, string proposal) external 
269     {
270         require(isVoter(tx.origin) && !mStopped && !isChain(chain));
271         
272         if(!confirmation(uint256(keccak256(msg.data)))) return;
273         
274         mMaxChainCode++;
275         mChainToCode[chain] = mMaxChainCode;
276         mCodeToChain[mMaxChainCode] = chain;
277         
278         emit ChainAdded(chain, uint256(keccak256(msg.data)));
279     }
280     
281     function addApp(address app, uint32 chain, uint32 token, string proposal) external 
282     {
283         require(isVoter(tx.origin) && !mStopped && !isApper(app) && isChainCode(chain));
284         
285         if(!confirmation(uint256(keccak256(msg.data)))) return;
286         
287         mMaxAppCode++;
288         mAppToCode[uint256(app)] =mMaxAppCode;
289         mCodeToAppInfo[mMaxAppCode] = AppInfo(chain, token, uint256(app));
290         
291         emit AppAdded(app, chain, token, uint256(keccak256(msg.data)));
292     }
293     
294     function removeApp(uint32 code, string proposal) external 
295     {
296         require(isVoter(tx.origin) && !mStopped && isAppCode(code));
297         
298         if(!confirmation(uint256(keccak256(msg.data)))) return;
299     
300         delete mAppToCode[uint256(mCodeToAppInfo[code].app)];
301         
302         emit AppRemoved(code, uint256(keccak256(msg.data)));
303     }
304     
305     function mintByGateway(uint32 appCode, uint64 wad, address receiver, string proposal) external 
306     {
307         require(isVoter(tx.origin) && !mStopped && isAppCode(appCode));
308         
309         if(!confirmation(uint256(keccak256(msg.data)))) return;
310         
311         if (App(address(mCodeToAppInfo[appCode].app)).mint(receiver, wad))
312         {
313             emit MintByGateway(appCode, receiver, wad, uint256(keccak256(msg.data)));
314         }
315     }
316     
317     function changeGatewayAddr(uint32 appCode, address newer, string proposal) external 
318     {
319         require(isVoter(tx.origin) && !mStopped && isAppCode(appCode));
320         
321         if(!confirmation(uint256(keccak256(msg.data)))) return;
322         
323         if(App(address(mCodeToAppInfo[appCode].app)).changeGatewayAddr(newer)) 
324         {
325             emit GatewayAddrChanged(appCode, newer, uint256(keccak256(msg.data)));
326         }
327     }
328     
329     function burnForGateway(address from, string receiver, uint64 wad) external 
330     {
331         require(isApper(msg.sender));
332         emit BurnForGateway(mAppToCode[uint256(msg.sender)], from, receiver, wad);
333     }
334 }