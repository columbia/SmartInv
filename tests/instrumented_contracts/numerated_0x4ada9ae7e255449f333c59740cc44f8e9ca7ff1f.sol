1 pragma solidity ^0.4.11;
2 
3 contract ForklogBlockstarter {
4     
5     string public constant contract_md5 = "847df4b1ba31f28b9399b52d784e4a8e";
6     string public constant contract_sha256 = "cd195ff7ac4743a1c878f0100e138e36471bb79c0254d58806b8244080979116";
7     
8     mapping (address => bool) private signs;
9 
10     address private alex = 0x8D5bd2aBa04A07Bfa0cc976C73eD45B23cC6D6a2;
11     address private andrey = 0x688d12D97D0E480559B6bEB6EE9907B625c14Adb;
12     address private toly = 0x34972356Af9B8912c1DC2737fd43352A8146D23D;
13     address private eugene = 0x259BBd479Bd174129a3ccb007f608D52cd2630e9;
14 
15     // This function will be executed by default.
16     function() {
17         sing();
18     }
19     
20     function sing() {
21         singBy(msg.sender);
22     }
23     
24     function singBy(address signer) {
25         if (isSignedBy(signer)) return;
26         signs[signer] = true;
27     }
28     
29     function isSignedBy(address signer) constant returns (bool) {
30         return signs[signer] == true;
31     }
32     
33     function isSignedByAlex() constant returns (bool) {
34         return isSignedBy(alex);
35     }
36     
37     function isSignedByAndrey() constant returns (bool) {
38         return isSignedBy(andrey);
39     }
40     
41     function isSignedByToly() constant returns (bool) {
42         return isSignedBy(toly);
43     }
44     
45     function isSignedByEugene() constant returns (bool) {
46         return isSignedBy(eugene);
47     }
48     
49     function isSignedByAll() constant returns (bool) {
50         return (
51             isSignedByAlex() && 
52             isSignedByAndrey() && 
53             isSignedByToly() && 
54             isSignedByEugene()
55         );
56     }
57 }
58 
59 /*
60 
61 TEXT OF THE CONTRACT.
62 
63 To verify a hash of the contract use SHA256 or MD5.
64 You can find lots of SHA256 / MD5 generators online, for example:
65 
66 SHA256 online generators:
67 https://emn178.github.io/online-tools/sha256.html
68 http://www.xorbin.com/tools/sha256-hash-calculator
69 
70 MD5 online generators:
71 https://emn178.github.io/online-tools/md5.html
72 http://www.xorbin.com/tools/md5-hash-calculator
73 http://onlinemd5.com/
74 
75 The content of the contract goes below between long lines of stars (*).
76 Don't copy star lines when generating SHA256/MD5. Copy only text in between.
77 
78 ********************************************************************************
79 # Contract between Forklog and Blockstarter
80 
81 ## Signed on
82 
83 June 24, 2017
84 
85 ## Participants
86 
87 ### Blockstarter.co
88 
89 * Aleksandr Siman (https://facebook.com/alek.siman)
90 * Andrey Stegno (https://facebook.com/andrii.stegno)
91 
92 ### Forklog.com
93 
94 * Toly Kaplan (https://facebook.com/totkaplan)
95 * Eugene Muratov (https://facebook.com/eugene.muratov)
96 
97 ## Shares for Forklog
98 
99 5% of all Blockstarter tokens.
100 
101 5% from Blockstarter profit.
102 
103 10% of raised funds during presale (private ICO).
104 
105 Public ICO reward:
106 
107 * 10% up to 1 million USD.
108 * 9% from 1 to 2 million USD.
109 * 8% from 2 to 3 million USD.
110 * 7% from 3 to 4 million USD.
111 * 6% from 4 to 5 million USD.
112 * 5% from 5 million USD.
113 
114 ## Shares for Blockstarter
115 
116 15,000 USD from Forklog for development of Blockstarter.
117 
118 25% of all Blockstarter tokens.
119 
120 ## Shares for Presale contributors
121 
122 20% of all Blockstarter tokens.
123 
124 ## Shares for ICO contributors
125 
126 50% of all Blockstarter tokens.
127 
128 ## Blockstarter functionality
129 
130 In the next sections this document describes the functionlity to be implemented by Blockstarter.
131 
132 ---
133 
134 # <<< START AFTER FORKLOG CONTRIBUTION >>>
135 
136 Forklog contributes 15,000 USD for development of Blockstarter.
137 
138 # **Campaign**
139 
140 ## Startuper
141 
142 ### Create draft
143 
144 * Draft of campaign can be incomplete. All values can be empty.
145 
146 * Each draft has a unique URL. 
147 
148 ### Share draft
149 
150 At any moment it is possible to share draft with team / editors.
151 
152 ### Publish draft for review
153 
154 Once startupper thinks that campaign is well described, they post draft for validation to BlockStarter team.
155 
156 Other contributors can pre-validate a draft. This can be rewarded with Blockstarter tokens.
157 
158 ### Edit campaign
159 
160 At any given moment it’s possible to edit draft or even published campaign.
161 
162 When edited a published campaign there could be 2 options to go:
163 
164 1. Update on main site immediately, but additionally send updates to Blockstarter / other contributors, and if there are some strange changes - these changes can be discarded / rolled back.
165 
166 2. Don’t update on main site right away. Send for approval to Blockstarter / or other contributors.
167 
168 ## Contributor
169 
170 ### Follow campaign
171 
172 * Receive updates about changes in campaign
173 
174 * Receive email / chat-bot notification about upcoming campaigns he follows
175 
176 ### Submit edits if found any typos 
177 
178 It should be possible to submit campaign edits and get rewarded with tokens.
179 
180 ### Help with whitepaper
181 
182 * Review of existent WP.
183 
184 * Fix typos in WP.
185 
186 # List of campaigns
187 
188 ## General functionality for listing
189 
190 ### Filtering / sections
191 
192 * Upcoming
193 
194 * Ongoing
195 
196 * Past
197 
198 * Launching on Blockstarter
199 
200 * Launching on other platform
201 
202 * My Campaigns
203 
204 ### Sorting
205 
206 * By start date of campaign
207 
208 * By raised amount in USD
209 
210 # Bounty task tracker (bounty dashboard)
211 
212 ## Startupper
213 
214 ### Create bounty tasks
215 
216 Next values can be specified by startupper, when creating a bounty task:
217 
218 * Name task  (examples: Edit whitepaper, Write blog post, Find typos, etc.)
219 
220 * Describe task in details
221 
222 * Amount of reward in tokens
223 
224 * Deadline
225 
226 * Choose (*or create on the fly*) the bounty type (in order to easy match company needs with contributors offers in future)
227 
228 ### Manage bounty tasks
229 
230 All values specified during task creation can be hanged.
231 
232 New addition values can be provided while managing bounty tasks:
233 
234 ### Provide feedback to participants
235 
236 ## Contributor
237 
238 ### Find and participate in bounty task
239 
240 ### View feedback and status of provided work
241 
242 # Contribution wallet
243 
244 ## Startupper
245 
246 ### Enable support of different cryptocurrencies
247 
248 Possible supported coins: Bitcoin, Ethereum, Ethereum Classic, Litecoin, Waves, etc.
249 
250 ### Generate smart contract on Ethereum
251 
252 Smart contract uses default template created by Blockstarter using values specific to ICO campaign:
253 
254 * Start date
255 
256 * End date
257 
258 * Min cap
259 
260 * Max cap
261 
262 * Token symbol
263 
264 * Add a string "Created on BlockStarter.co" to generated smart contract.
265 
266 ### Generate tokens on Waves platform
267 
268 Use Waves API to issue tokens seamlessly without a headache. 
269 
270 ### Generate smart contract or issues tokens on other platforms
271 
272 Bitshares, NXT, Wings, other?
273 
274 ### Publish all generated contracts to GitHub
275 
276 It should be possible to see all contracts generated for campaigns that launched on Blockstarter.
277 
278 Contracts could be published to a specific directory of Blockstarter repo called "contracts".
279 
280 Provide Github Gist link to the draft contract.
281 
282 ### View totals in real time
283 
284 At any given moment startupper can see a progress of their campaign:
285 
286 * Total amount in USD
287 
288 * Total amount in every cryptocurrency, that campaign supports.
289 
290 * Total number of contributors.
291 
292 ## Contributor
293 
294 ### Select campaign for contribution
295 
296 ### Accept terms of campaign and enter crowdsale
297 
298 ### Choose currency for contribution (Ether, Waves, etc.)
299 
300 List of contributions and ability to sell and buy tokens between users or buy token when crowdsale is started
301 
302 ---
303 
304 # <<< START AFTER SUCCESSFUL PRESALE >>>
305 
306 Presale is considered successful if Blockstarter raises more than 250,000 USD.
307 
308 # Autoinvest in 3rd party campaigns
309 
310 It should be possible to join auto investment into big ICOs even if they take place not on Blockstarter.
311 
312 ## Contributor
313 
314 ### Top up deposit on Blockstarter
315 
316 Contributor puts some amount of money to his Blockstarter account.
317 
318 Then it will be possible to use any amount of that money when participating in autoinvestment into campaigns that take place on other platforms.
319 
320 ### How to autoinvest for contributor
321 
322 * List of campaigns where you can autoinvest
323 
324 * Choose campaign to autoinvest.
325 
326 * Decide how much you want to autoinvest.
327 
328 * Submit your decision.
329 
330 ## BlockStarter
331 
332 ### How to manage autoinvesments
333 
334 * Blockstarter accepts autoinvestment applications up until 3 days before 3rd party campaign starts.
335 
336 * Blockstarter converts all funds to the currencies, that are accepted by 3rd party campaign. For example if campaign accepts Ethers only, but BS collected Bitcoins and Waves, it could be possible to convert all these to Ether and invest into campaign using Ethers.
337 
338 * On the day when campaign starts, Blockstarter makes one big investment into 3rd party ICO.
339 
340 # XBS token and economy of BlockStarter
341 
342 XBS tokens could be used in different cases:
343 
344 * Fee for usage of Blockstarter services: publish campaign, publish bounty, publish smart contract.
345 
346 * Payment for mass feedback to fix conceptual bugs. 
347 
348 * Payment for promotions of campaign, bounties, jobs and it’s position in the list.
349 
350 * Payment for work made by contributor or employee.
351 
352 * Reward for bounty in contrast to unissued tokens of a project.
353 
354 * Payment for event posting on the Blockstarter related to the ICO to attract contributors.
355 
356 ## Fee for usage of Blockstarter services
357 
358 Let’s assume that 1 XBS token = 1 USD.
359 
360 * When creating a new campaign it is required to topup your Blockstarter balance to 500 tokens. 
361 
362 * 50-100 tokens (10-20% of them) go to Blockstarter.
363 
364 * 400 tokens left on startupper deposit. Startupper can use these tokens later to pay for work of other contributors: improve whitepaper, legal consultancy, artwork, etc.
365 
366 * After all startupper will have 400 XBS tokens that could be used in different cases as we see below.
367 
368 ## Payment for promotions
369 
370 Having big listing it’s always hard to be noticed naturally. Especially if you are unknown project.
371 
372 XBS tokens can be used to pay for promotions of crowdsale campaigns and bounties.
373 
374 Having hundreds to thousands of campaigns on site it will be hard to outstand.
375 
376 By paying for, let’s say 1000 tokens will give a campaign 1000 extra views by showing the campaign on the top of Blockstarter site.
377 
378 The similar situation could be with bounties or job entries: there could be thousands of different bounties and to get on top of other bounties, a project will pay some XBS tokens.
379 
380 ## Reward for bounty
381 
382 It should be possible to pay for bounty with non existent tokens of any particular project that is going to launch crowdsale. This is a good way for project to save money and to get some work done for free. But from the other side this way of payment is not safe for workers/contributors, because there is a big chance that project will not success in crowdsale because of big competition between other projects.
383 
384 XBS tokens as a payment reward for bounty could be a good alternative. Every project could have XBS tokens on its deposit (for example after a required topup during publishing of ICO campaign), and these tokens could be used as a reward for bounty tasks instead of unissued tokens of project. XBS tokens will be more respected and safe way to pay for the job, such as they will be tradeable at that moment in contrast to unissued tokens of a project. 
385 
386 ## Payment for work
387 
388 XBS tokens could be used as a currency that projects will use to pay salary for their employees or as a one time payment to freelancers. What kind of work can be payed with XBS tokens?
389 
390 * Improve/review whitepaper.
391 
392 * Legal support / consultancy.
393 
394 * Copywriting and PR.
395 
396 * Programming related tasks.
397 
398 * Design and artwork.
399 
400 * Regular salary for employee.
401 
402 * One time payment for freelancer.
403 
404 ## Fee from money raised during ICO
405 
406 Blockstarter will take next % from money each campaign raise during ICO:
407 
408 * 10% up to 1m USD.
409 
410 * 5% from 1m to 10m USD.
411 
412 * 2.5% from 10m USD.
413 
414 ---
415 
416 # <<< START AFTER SUCCESSFUL ICO >>>
417 
418 Public ICO is considered successful if Blockstarter raises more than 2,000,000 USD.
419 
420 # Marketplace for contributors
421 
422 ## Contributor
423 
424 Contributor can help a campaign in different ways, for example:
425 
426 ### Edit Whitepaper or give a feedback
427 
428 ### Help with coding or design work
429 
430 ### Help with legal aspects
431 
432 ### Help with PR
433 
434 ### Write an article / blog post about campaign
435 
436 ---
437 
438 # APPENDIX A: Media plan for BlockStarter
439 
440 ## Create simple blog on Blockstarter
441 
442 * It should be server generated (SEO friendly)
443 
444 * It should lightweight. Just simple Markdown?
445 
446 ## Write ICO digests every week on Blockstarter blog
447 
448 * A digest should describe most notable past and upcoming ICOs including ICOs that took/will take place either on Blockstarter or 3rd party platform
449 
450 * ForkLog should help with copywriting for ICO digests.
451 
452 ## Write news about Blostarter: features, updates, news
453 
454 * Write news and announcements on ForkLog.
455 
456 * Write some stuff on Blockstarter blog.
457 
458 ## Create video reviews of ICOs using screencast of Blockstarter
459 
460 * For first time these videos could be published to YouTube channel of Forklog.
461 
462 * If they are interesting for audience, later they can be published to dedicated channel of Blockstarter.
463 ********************************************************************************
464 
465 */