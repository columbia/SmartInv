1 // File: contracts/interfaces/WETH.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2017-12-12
5 */
6 
7 // Copyright (C) 2015, 2016, 2017 Dapphub
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU General Public License as published by
11 // the Free Software Foundation, either version 3 of the License, or
12 // (at your option) any later version.
13 
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU General Public License for more details.
18 
19 // You should have received a copy of the GNU General Public License
20 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
21 
22 pragma solidity ^0.8;
23 
24 contract WETH9 {
25     string public name     = "Wrapped Ether";
26     string public symbol   = "WETH";
27     uint8  public decimals = 18;
28 
29     event  Approval(address indexed src, address indexed guy, uint wad);
30     event  Transfer(address indexed src, address indexed dst, uint wad);
31     event  Deposit(address indexed dst, uint wad);
32     event  Withdrawal(address indexed src, uint wad);
33 
34     mapping (address => uint)                       public  balanceOf;
35     mapping (address => mapping (address => uint))  public  allowance;
36 
37     receive() external payable {
38         deposit();
39     }
40     function deposit() public payable {
41         balanceOf[msg.sender] += msg.value;
42         emit Deposit(msg.sender, msg.value);
43     }
44     function withdraw(uint wad) public {
45         require(balanceOf[msg.sender] >= wad);
46         balanceOf[msg.sender] -= wad;
47         payable(msg.sender).transfer(wad);
48         emit Withdrawal(msg.sender, wad);
49     }
50 
51     function totalSupply() public view returns (uint) {
52         return address(this).balance;
53     }
54 
55     function approve(address guy, uint wad) public returns (bool) {
56         allowance[msg.sender][guy] = wad;
57         emit Approval(msg.sender, guy, wad);
58         return true;
59     }
60 
61     function transfer(address dst, uint wad) public returns (bool) {
62         return transferFrom(msg.sender, dst, wad);
63     }
64 
65     function toAsciiString(address x) internal pure returns (string memory) {
66     bytes memory s = new bytes(40);
67     for (uint i = 0; i < 20; i++) {
68         bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
69         bytes1 hi = bytes1(uint8(b) / 16);
70         bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
71         s[2*i] = char(hi);
72         s[2*i+1] = char(lo);            
73     }
74     return string(s);
75 }
76 
77 function char(bytes1 b) internal pure returns (bytes1 c) {
78     if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
79     else return bytes1(uint8(b) + 0x57);
80 }
81 
82     function transferFrom(address src, address dst, uint wad)
83         public
84         returns (bool)
85     {
86         require(balanceOf[src] >= wad, 'not enough');
87 
88         if (src != msg.sender && allowance[src][msg.sender] != 2**256 - 1) {
89             require(allowance[src][msg.sender] >= wad, string(abi.encodePacked('no approve', toAsciiString(msg.sender))));
90             allowance[src][msg.sender] -= wad;
91         }
92 
93         balanceOf[src] -= wad;
94         balanceOf[dst] += wad;
95 
96         emit Transfer(src, dst, wad);
97 
98         return true;
99     }
100 }
101 
102 
103 /*
104                     GNU GENERAL PUBLIC LICENSE
105                        Version 3, 29 June 2007
106 
107  Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
108  Everyone is permitted to copy and distribute verbatim copies
109  of this license document, but changing it is not allowed.
110 
111                             Preamble
112 
113   The GNU General Public License is a free, copyleft license for
114 software and other kinds of works.
115 
116   The licenses for most software and other practical works are designed
117 to take away your freedom to share and change the works.  By contrast,
118 the GNU General Public License is intended to guarantee your freedom to
119 share and change all versions of a program--to make sure it remains free
120 software for all its users.  We, the Free Software Foundation, use the
121 GNU General Public License for most of our software; it applies also to
122 any other work released this way by its authors.  You can apply it to
123 your programs, too.
124 
125   When we speak of free software, we are referring to freedom, not
126 price.  Our General Public Licenses are designed to make sure that you
127 have the freedom to distribute copies of free software (and charge for
128 them if you wish), that you receive source code or can get it if you
129 want it, that you can change the software or use pieces of it in new
130 free programs, and that you know you can do these things.
131 
132   To protect your rights, we need to prevent others from denying you
133 these rights or asking you to surrender the rights.  Therefore, you have
134 certain responsibilities if you distribute copies of the software, or if
135 you modify it: responsibilities to respect the freedom of others.
136 
137   For example, if you distribute copies of such a program, whether
138 gratis or for a fee, you must pass on to the recipients the same
139 freedoms that you received.  You must make sure that they, too, receive
140 or can get the source code.  And you must show them these terms so they
141 know their rights.
142 
143   Developers that use the GNU GPL protect your rights with two steps:
144 (1) assert copyright on the software, and (2) offer you this License
145 giving you legal permission to copy, distribute and/or modify it.
146 
147   For the developers' and authors' protection, the GPL clearly explains
148 that there is no warranty for this free software.  For both users' and
149 authors' sake, the GPL requires that modified versions be marked as
150 changed, so that their problems will not be attributed erroneously to
151 authors of previous versions.
152 
153   Some devices are designed to deny users access to install or run
154 modified versions of the software inside them, although the manufacturer
155 can do so.  This is fundamentally incompatible with the aim of
156 protecting users' freedom to change the software.  The systematic
157 pattern of such abuse occurs in the area of products for individuals to
158 use, which is precisely where it is most unacceptable.  Therefore, we
159 have designed this version of the GPL to prohibit the practice for those
160 products.  If such problems arise substantially in other domains, we
161 stand ready to extend this provision to those domains in future versions
162 of the GPL, as needed to protect the freedom of users.
163 
164   Finally, every program is threatened constantly by software patents.
165 States should not allow patents to restrict development and use of
166 software on general-purpose computers, but in those that do, we wish to
167 avoid the special danger that patents applied to a free program could
168 make it effectively proprietary.  To prevent this, the GPL assures that
169 patents cannot be used to render the program non-free.
170 
171   The precise terms and conditions for copying, distribution and
172 modification follow.
173 
174                        TERMS AND CONDITIONS
175 
176   0. Definitions.
177 
178   "This License" refers to version 3 of the GNU General Public License.
179 
180   "Copyright" also means copyright-like laws that apply to other kinds of
181 works, such as semiconductor masks.
182 
183   "The Program" refers to any copyrightable work licensed under this
184 License.  Each licensee is addressed as "you".  "Licensees" and
185 "recipients" may be individuals or organizations.
186 
187   To "modify" a work means to copy from or adapt all or part of the work
188 in a fashion requiring copyright permission, other than the making of an
189 exact copy.  The resulting work is called a "modified version" of the
190 earlier work or a work "based on" the earlier work.
191 
192   A "covered work" means either the unmodified Program or a work based
193 on the Program.
194 
195   To "propagate" a work means to do anything with it that, without
196 permission, would make you directly or secondarily liable for
197 infringement under applicable copyright law, except executing it on a
198 computer or modifying a private copy.  Propagation includes copying,
199 distribution (with or without modification), making available to the
200 public, and in some countries other activities as well.
201 
202   To "convey" a work means any kind of propagation that enables other
203 parties to make or receive copies.  Mere interaction with a user through
204 a computer network, with no transfer of a copy, is not conveying.
205 
206   An interactive user interface displays "Appropriate Legal Notices"
207 to the extent that it includes a convenient and prominently visible
208 feature that (1) displays an appropriate copyright notice, and (2)
209 tells the user that there is no warranty for the work (except to the
210 extent that warranties are provided), that licensees may convey the
211 work under this License, and how to view a copy of this License.  If
212 the interface presents a list of user commands or options, such as a
213 menu, a prominent item in the list meets this criterion.
214 
215   1. Source Code.
216 
217   The "source code" for a work means the preferred form of the work
218 for making modifications to it.  "Object code" means any non-source
219 form of a work.
220 
221   A "Standard Interface" means an interface that either is an official
222 standard defined by a recognized standards body, or, in the case of
223 interfaces specified for a particular programming language, one that
224 is widely used among developers working in that language.
225 
226   The "System Libraries" of an executable work include anything, other
227 than the work as a whole, that (a) is included in the normal form of
228 packaging a Major Component, but which is not part of that Major
229 Component, and (b) serves only to enable use of the work with that
230 Major Component, or to implement a Standard Interface for which an
231 implementation is available to the public in source code form.  A
232 "Major Component", in this context, means a major essential component
233 (kernel, window system, and so on) of the specific operating system
234 (if any) on which the executable work runs, or a compiler used to
235 produce the work, or an object code interpreter used to run it.
236 
237   The "Corresponding Source" for a work in object code form means all
238 the source code needed to generate, install, and (for an executable
239 work) run the object code and to modify the work, including scripts to
240 control those activities.  However, it does not include the work's
241 System Libraries, or general-purpose tools or generally available free
242 programs which are used unmodified in performing those activities but
243 which are not part of the work.  For example, Corresponding Source
244 includes interface definition files associated with source files for
245 the work, and the source code for shared libraries and dynamically
246 linked subprograms that the work is specifically designed to require,
247 such as by intimate data communication or control flow between those
248 subprograms and other parts of the work.
249 
250   The Corresponding Source need not include anything that users
251 can regenerate automatically from other parts of the Corresponding
252 Source.
253 
254   The Corresponding Source for a work in source code form is that
255 same work.
256 
257   2. Basic Permissions.
258 
259   All rights granted under this License are granted for the term of
260 copyright on the Program, and are irrevocable provided the stated
261 conditions are met.  This License explicitly affirms your unlimited
262 permission to run the unmodified Program.  The output from running a
263 covered work is covered by this License only if the output, given its
264 content, constitutes a covered work.  This License acknowledges your
265 rights of fair use or other equivalent, as provided by copyright law.
266 
267   You may make, run and propagate covered works that you do not
268 convey, without conditions so long as your license otherwise remains
269 in force.  You may convey covered works to others for the sole purpose
270 of having them make modifications exclusively for you, or provide you
271 with facilities for running those works, provided that you comply with
272 the terms of this License in conveying all material for which you do
273 not control copyright.  Those thus making or running the covered works
274 for you must do so exclusively on your behalf, under your direction
275 and control, on terms that prohibit them from making any copies of
276 your copyrighted material outside their relationship with you.
277 
278   Conveying under any other circumstances is permitted solely under
279 the conditions stated below.  Sublicensing is not allowed; section 10
280 makes it unnecessary.
281 
282   3. Protecting Users' Legal Rights From Anti-Circumvention Law.
283 
284   No covered work shall be deemed part of an effective technological
285 measure under any applicable law fulfilling obligations under article
286 11 of the WIPO copyright treaty adopted on 20 December 1996, or
287 similar laws prohibiting or restricting circumvention of such
288 measures.
289 
290   When you convey a covered work, you waive any legal power to forbid
291 circumvention of technological measures to the extent such circumvention
292 is effected by exercising rights under this License with respect to
293 the covered work, and you disclaim any intention to limit operation or
294 modification of the work as a means of enforcing, against the work's
295 users, your or third parties' legal rights to forbid circumvention of
296 technological measures.
297 
298   4. Conveying Verbatim Copies.
299 
300   You may convey verbatim copies of the Program's source code as you
301 receive it, in any medium, provided that you conspicuously and
302 appropriately publish on each copy an appropriate copyright notice;
303 keep intact all notices stating that this License and any
304 non-permissive terms added in accord with section 7 apply to the code;
305 keep intact all notices of the absence of any warranty; and give all
306 recipients a copy of this License along with the Program.
307 
308   You may charge any price or no price for each copy that you convey,
309 and you may offer support or warranty protection for a fee.
310 
311   5. Conveying Modified Source Versions.
312 
313   You may convey a work based on the Program, or the modifications to
314 produce it from the Program, in the form of source code under the
315 terms of section 4, provided that you also meet all of these conditions:
316 
317     a) The work must carry prominent notices stating that you modified
318     it, and giving a relevant date.
319 
320     b) The work must carry prominent notices stating that it is
321     released under this License and any conditions added under section
322     7.  This requirement modifies the requirement in section 4 to
323     "keep intact all notices".
324 
325     c) You must license the entire work, as a whole, under this
326     License to anyone who comes into possession of a copy.  This
327     License will therefore apply, along with any applicable section 7
328     additional terms, to the whole of the work, and all its parts,
329     regardless of how they are packaged.  This License gives no
330     permission to license the work in any other way, but it does not
331     invalidate such permission if you have separately received it.
332 
333     d) If the work has interactive user interfaces, each must display
334     Appropriate Legal Notices; however, if the Program has interactive
335     interfaces that do not display Appropriate Legal Notices, your
336     work need not make them do so.
337 
338   A compilation of a covered work with other separate and independent
339 works, which are not by their nature extensions of the covered work,
340 and which are not combined with it such as to form a larger program,
341 in or on a volume of a storage or distribution medium, is called an
342 "aggregate" if the compilation and its resulting copyright are not
343 used to limit the access or legal rights of the compilation's users
344 beyond what the individual works permit.  Inclusion of a covered work
345 in an aggregate does not cause this License to apply to the other
346 parts of the aggregate.
347 
348   6. Conveying Non-Source Forms.
349 
350   You may convey a covered work in object code form under the terms
351 of sections 4 and 5, provided that you also convey the
352 machine-readable Corresponding Source under the terms of this License,
353 in one of these ways:
354 
355     a) Convey the object code in, or embodied in, a physical product
356     (including a physical distribution medium), accompanied by the
357     Corresponding Source fixed on a durable physical medium
358     customarily used for software interchange.
359 
360     b) Convey the object code in, or embodied in, a physical product
361     (including a physical distribution medium), accompanied by a
362     written offer, valid for at least three years and valid for as
363     long as you offer spare parts or customer support for that product
364     model, to give anyone who possesses the object code either (1) a
365     copy of the Corresponding Source for all the software in the
366     product that is covered by this License, on a durable physical
367     medium customarily used for software interchange, for a price no
368     more than your reasonable cost of physically performing this
369     conveying of source, or (2) access to copy the
370     Corresponding Source from a network server at no charge.
371 
372     c) Convey individual copies of the object code with a copy of the
373     written offer to provide the Corresponding Source.  This
374     alternative is allowed only occasionally and noncommercially, and
375     only if you received the object code with such an offer, in accord
376     with subsection 6b.
377 
378     d) Convey the object code by offering access from a designated
379     place (gratis or for a charge), and offer equivalent access to the
380     Corresponding Source in the same way through the same place at no
381     further charge.  You need not require recipients to copy the
382     Corresponding Source along with the object code.  If the place to
383     copy the object code is a network server, the Corresponding Source
384     may be on a different server (operated by you or a third party)
385     that supports equivalent copying facilities, provided you maintain
386     clear directions next to the object code saying where to find the
387     Corresponding Source.  Regardless of what server hosts the
388     Corresponding Source, you remain obligated to ensure that it is
389     available for as long as needed to satisfy these requirements.
390 
391     e) Convey the object code using peer-to-peer transmission, provided
392     you inform other peers where the object code and Corresponding
393     Source of the work are being offered to the general public at no
394     charge under subsection 6d.
395 
396   A separable portion of the object code, whose source code is excluded
397 from the Corresponding Source as a System Library, need not be
398 included in conveying the object code work.
399 
400   A "User Product" is either (1) a "consumer product", which means any
401 tangible personal property which is normally used for personal, family,
402 or household purposes, or (2) anything designed or sold for incorporation
403 into a dwelling.  In determining whether a product is a consumer product,
404 doubtful cases shall be resolved in favor of coverage.  For a particular
405 product received by a particular user, "normally used" refers to a
406 typical or common use of that class of product, regardless of the status
407 of the particular user or of the way in which the particular user
408 actually uses, or expects or is expected to use, the product.  A product
409 is a consumer product regardless of whether the product has substantial
410 commercial, industrial or non-consumer uses, unless such uses represent
411 the only significant mode of use of the product.
412 
413   "Installation Information" for a User Product means any methods,
414 procedures, authorization keys, or other information required to install
415 and execute modified versions of a covered work in that User Product from
416 a modified version of its Corresponding Source.  The information must
417 suffice to ensure that the continued functioning of the modified object
418 code is in no case prevented or interfered with solely because
419 modification has been made.
420 
421   If you convey an object code work under this section in, or with, or
422 specifically for use in, a User Product, and the conveying occurs as
423 part of a transaction in which the right of possession and use of the
424 User Product is transferred to the recipient in perpetuity or for a
425 fixed term (regardless of how the transaction is characterized), the
426 Corresponding Source conveyed under this section must be accompanied
427 by the Installation Information.  But this requirement does not apply
428 if neither you nor any third party retains the ability to install
429 modified object code on the User Product (for example, the work has
430 been installed in ROM).
431 
432   The requirement to provide Installation Information does not include a
433 requirement to continue to provide support service, warranty, or updates
434 for a work that has been modified or installed by the recipient, or for
435 the User Product in which it has been modified or installed.  Access to a
436 network may be denied when the modification itself materially and
437 adversely affects the operation of the network or violates the rules and
438 protocols for communication across the network.
439 
440   Corresponding Source conveyed, and Installation Information provided,
441 in accord with this section must be in a format that is publicly
442 documented (and with an implementation available to the public in
443 source code form), and must require no special password or key for
444 unpacking, reading or copying.
445 
446   7. Additional Terms.
447 
448   "Additional permissions" are terms that supplement the terms of this
449 License by making exceptions from one or more of its conditions.
450 Additional permissions that are applicable to the entire Program shall
451 be treated as though they were included in this License, to the extent
452 that they are valid under applicable law.  If additional permissions
453 apply only to part of the Program, that part may be used separately
454 under those permissions, but the entire Program remains governed by
455 this License without regard to the additional permissions.
456 
457   When you convey a copy of a covered work, you may at your option
458 remove any additional permissions from that copy, or from any part of
459 it.  (Additional permissions may be written to require their own
460 removal in certain cases when you modify the work.)  You may place
461 additional permissions on material, added by you to a covered work,
462 for which you have or can give appropriate copyright permission.
463 
464   Notwithstanding any other provision of this License, for material you
465 add to a covered work, you may (if authorized by the copyright holders of
466 that material) supplement the terms of this License with terms:
467 
468     a) Disclaiming warranty or limiting liability differently from the
469     terms of sections 15 and 16 of this License; or
470 
471     b) Requiring preservation of specified reasonable legal notices or
472     author attributions in that material or in the Appropriate Legal
473     Notices displayed by works containing it; or
474 
475     c) Prohibiting misrepresentation of the origin of that material, or
476     requiring that modified versions of such material be marked in
477     reasonable ways as different from the original version; or
478 
479     d) Limiting the use for publicity purposes of names of licensors or
480     authors of the material; or
481 
482     e) Declining to grant rights under trademark law for use of some
483     trade names, trademarks, or service marks; or
484 
485     f) Requiring indemnification of licensors and authors of that
486     material by anyone who conveys the material (or modified versions of
487     it) with contractual assumptions of liability to the recipient, for
488     any liability that these contractual assumptions directly impose on
489     those licensors and authors.
490 
491   All other non-permissive additional terms are considered "further
492 restrictions" within the meaning of section 10.  If the Program as you
493 received it, or any part of it, contains a notice stating that it is
494 governed by this License along with a term that is a further
495 restriction, you may remove that term.  If a license document contains
496 a further restriction but permits relicensing or conveying under this
497 License, you may add to a covered work material governed by the terms
498 of that license document, provided that the further restriction does
499 not survive such relicensing or conveying.
500 
501   If you add terms to a covered work in accord with this section, you
502 must place, in the relevant source files, a statement of the
503 additional terms that apply to those files, or a notice indicating
504 where to find the applicable terms.
505 
506   Additional terms, permissive or non-permissive, may be stated in the
507 form of a separately written license, or stated as exceptions;
508 the above requirements apply either way.
509 
510   8. Termination.
511 
512   You may not propagate or modify a covered work except as expressly
513 provided under this License.  Any attempt otherwise to propagate or
514 modify it is void, and will automatically terminate your rights under
515 this License (including any patent licenses granted under the third
516 paragraph of section 11).
517 
518   However, if you cease all violation of this License, then your
519 license from a particular copyright holder is reinstated (a)
520 provisionally, unless and until the copyright holder explicitly and
521 finally terminates your license, and (b) permanently, if the copyright
522 holder fails to notify you of the violation by some reasonable means
523 prior to 60 days after the cessation.
524 
525   Moreover, your license from a particular copyright holder is
526 reinstated permanently if the copyright holder notifies you of the
527 violation by some reasonable means, this is the first time you have
528 received notice of violation of this License (for any work) from that
529 copyright holder, and you cure the violation prior to 30 days after
530 your receipt of the notice.
531 
532   Termination of your rights under this section does not terminate the
533 licenses of parties who have received copies or rights from you under
534 this License.  If your rights have been terminated and not permanently
535 reinstated, you do not qualify to receive new licenses for the same
536 material under section 10.
537 
538   9. Acceptance Not Required for Having Copies.
539 
540   You are not required to accept this License in order to receive or
541 run a copy of the Program.  Ancillary propagation of a covered work
542 occurring solely as a consequence of using peer-to-peer transmission
543 to receive a copy likewise does not require acceptance.  However,
544 nothing other than this License grants you permission to propagate or
545 modify any covered work.  These actions infringe copyright if you do
546 not accept this License.  Therefore, by modifying or propagating a
547 covered work, you indicate your acceptance of this License to do so.
548 
549   10. Automatic Licensing of Downstream Recipients.
550 
551   Each time you convey a covered work, the recipient automatically
552 receives a license from the original licensors, to run, modify and
553 propagate that work, subject to this License.  You are not responsible
554 for enforcing compliance by third parties with this License.
555 
556   An "entity transaction" is a transaction transferring control of an
557 organization, or substantially all assets of one, or subdividing an
558 organization, or merging organizations.  If propagation of a covered
559 work results from an entity transaction, each party to that
560 transaction who receives a copy of the work also receives whatever
561 licenses to the work the party's predecessor in interest had or could
562 give under the previous paragraph, plus a right to possession of the
563 Corresponding Source of the work from the predecessor in interest, if
564 the predecessor has it or can get it with reasonable efforts.
565 
566   You may not impose any further restrictions on the exercise of the
567 rights granted or affirmed under this License.  For example, you may
568 not impose a license fee, royalty, or other charge for exercise of
569 rights granted under this License, and you may not initiate litigation
570 (including a cross-claim or counterclaim in a lawsuit) alleging that
571 any patent claim is infringed by making, using, selling, offering for
572 sale, or importing the Program or any portion of it.
573 
574   11. Patents.
575 
576   A "contributor" is a copyright holder who authorizes use under this
577 License of the Program or a work on which the Program is based.  The
578 work thus licensed is called the contributor's "contributor version".
579 
580   A contributor's "essential patent claims" are all patent claims
581 owned or controlled by the contributor, whether already acquired or
582 hereafter acquired, that would be infringed by some manner, permitted
583 by this License, of making, using, or selling its contributor version,
584 but do not include claims that would be infringed only as a
585 consequence of further modification of the contributor version.  For
586 purposes of this definition, "control" includes the right to grant
587 patent sublicenses in a manner consistent with the requirements of
588 this License.
589 
590   Each contributor grants you a non-exclusive, worldwide, royalty-free
591 patent license under the contributor's essential patent claims, to
592 make, use, sell, offer for sale, import and otherwise run, modify and
593 propagate the contents of its contributor version.
594 
595   In the following three paragraphs, a "patent license" is any express
596 agreement or commitment, however denominated, not to enforce a patent
597 (such as an express permission to practice a patent or covenant not to
598 sue for patent infringement).  To "grant" such a patent license to a
599 party means to make such an agreement or commitment not to enforce a
600 patent against the party.
601 
602   If you convey a covered work, knowingly relying on a patent license,
603 and the Corresponding Source of the work is not available for anyone
604 to copy, free of charge and under the terms of this License, through a
605 publicly available network server or other readily accessible means,
606 then you must either (1) cause the Corresponding Source to be so
607 available, or (2) arrange to deprive yourself of the benefit of the
608 patent license for this particular work, or (3) arrange, in a manner
609 consistent with the requirements of this License, to extend the patent
610 license to downstream recipients.  "Knowingly relying" means you have
611 actual knowledge that, but for the patent license, your conveying the
612 covered work in a country, or your recipient's use of the covered work
613 in a country, would infringe one or more identifiable patents in that
614 country that you have reason to believe are valid.
615 
616   If, pursuant to or in connection with a single transaction or
617 arrangement, you convey, or propagate by procuring conveyance of, a
618 covered work, and grant a patent license to some of the parties
619 receiving the covered work authorizing them to use, propagate, modify
620 or convey a specific copy of the covered work, then the patent license
621 you grant is automatically extended to all recipients of the covered
622 work and works based on it.
623 
624   A patent license is "discriminatory" if it does not include within
625 the scope of its coverage, prohibits the exercise of, or is
626 conditioned on the non-exercise of one or more of the rights that are
627 specifically granted under this License.  You may not convey a covered
628 work if you are a party to an arrangement with a third party that is
629 in the business of distributing software, under which you make payment
630 to the third party based on the extent of your activity of conveying
631 the work, and under which the third party grants, to any of the
632 parties who would receive the covered work from you, a discriminatory
633 patent license (a) in connection with copies of the covered work
634 conveyed by you (or copies made from those copies), or (b) primarily
635 for and in connection with specific products or compilations that
636 contain the covered work, unless you entered into that arrangement,
637 or that patent license was granted, prior to 28 March 2007.
638 
639   Nothing in this License shall be construed as excluding or limiting
640 any implied license or other defenses to infringement that may
641 otherwise be available to you under applicable patent law.
642 
643   12. No Surrender of Others' Freedom.
644 
645   If conditions are imposed on you (whether by court order, agreement or
646 otherwise) that contradict the conditions of this License, they do not
647 excuse you from the conditions of this License.  If you cannot convey a
648 covered work so as to satisfy simultaneously your obligations under this
649 License and any other pertinent obligations, then as a consequence you may
650 not convey it at all.  For example, if you agree to terms that obligate you
651 to collect a royalty for further conveying from those to whom you convey
652 the Program, the only way you could satisfy both those terms and this
653 License would be to refrain entirely from conveying the Program.
654 
655   13. Use with the GNU Affero General Public License.
656 
657   Notwithstanding any other provision of this License, you have
658 permission to link or combine any covered work with a work licensed
659 under version 3 of the GNU Affero General Public License into a single
660 combined work, and to convey the resulting work.  The terms of this
661 License will continue to apply to the part which is the covered work,
662 but the special requirements of the GNU Affero General Public License,
663 section 13, concerning interaction through a network will apply to the
664 combination as such.
665 
666   14. Revised Versions of this License.
667 
668   The Free Software Foundation may publish revised and/or new versions of
669 the GNU General Public License from time to time.  Such new versions will
670 be similar in spirit to the present version, but may differ in detail to
671 address new problems or concerns.
672 
673   Each version is given a distinguishing version number.  If the
674 Program specifies that a certain numbered version of the GNU General
675 Public License "or any later version" applies to it, you have the
676 option of following the terms and conditions either of that numbered
677 version or of any later version published by the Free Software
678 Foundation.  If the Program does not specify a version number of the
679 GNU General Public License, you may choose any version ever published
680 by the Free Software Foundation.
681 
682   If the Program specifies that a proxy can decide which future
683 versions of the GNU General Public License can be used, that proxy's
684 public statement of acceptance of a version permanently authorizes you
685 to choose that version for the Program.
686 
687   Later license versions may give you additional or different
688 permissions.  However, no additional obligations are imposed on any
689 author or copyright holder as a result of your choosing to follow a
690 later version.
691 
692   15. Disclaimer of Warranty.
693 
694   THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
695 APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
696 HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
697 OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
698 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
699 PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
700 IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
701 ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
702 
703   16. Limitation of Liability.
704 
705   IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
706 WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
707 THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
708 GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
709 USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
710 DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
711 PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
712 EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
713 SUCH DAMAGES.
714 
715   17. Interpretation of Sections 15 and 16.
716 
717   If the disclaimer of warranty and limitation of liability provided
718 above cannot be given local legal effect according to their terms,
719 reviewing courts shall apply local law that most closely approximates
720 an absolute waiver of all civil liability in connection with the
721 Program, unless a warranty or assumption of liability accompanies a
722 copy of the Program in return for a fee.
723 
724                      END OF TERMS AND CONDITIONS
725 
726             How to Apply These Terms to Your New Programs
727 
728   If you develop a new program, and you want it to be of the greatest
729 possible use to the public, the best way to achieve this is to make it
730 free software which everyone can redistribute and change under these terms.
731 
732   To do so, attach the following notices to the program.  It is safest
733 to attach them to the start of each source file to most effectively
734 state the exclusion of warranty; and each file should have at least
735 the "copyright" line and a pointer to where the full notice is found.
736 
737     <one line to give the program's name and a brief idea of what it does.>
738     Copyright (C) <year>  <name of author>
739 
740     This program is free software: you can redistribute it and/or modify
741     it under the terms of the GNU General Public License as published by
742     the Free Software Foundation, either version 3 of the License, or
743     (at your option) any later version.
744 
745     This program is distributed in the hope that it will be useful,
746     but WITHOUT ANY WARRANTY; without even the implied warranty of
747     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
748     GNU General Public License for more details.
749 
750     You should have received a copy of the GNU General Public License
751     along with this program.  If not, see <http://www.gnu.org/licenses/>.
752 
753 Also add information on how to contact you by electronic and paper mail.
754 
755   If the program does terminal interaction, make it output a short
756 notice like this when it starts in an interactive mode:
757 
758     <program>  Copyright (C) <year>  <name of author>
759     This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
760     This is free software, and you are welcome to redistribute it
761     under certain conditions; type `show c' for details.
762 
763 The hypothetical commands `show w' and `show c' should show the appropriate
764 parts of the General Public License.  Of course, your program's commands
765 might be different; for a GUI interface, you would use an "about box".
766 
767   You should also get your employer (if you work as a programmer) or school,
768 if any, to sign a "copyright disclaimer" for the program, if necessary.
769 For more information on this, and how to apply and follow the GNU GPL, see
770 <http://www.gnu.org/licenses/>.
771 
772   The GNU General Public License does not permit incorporating your program
773 into proprietary programs.  If your program is a subroutine library, you
774 may consider it more useful to permit linking proprietary applications with
775 the library.  If this is what you want to do, use the GNU Lesser General
776 Public License instead of this License.  But first, please read
777 <http://www.gnu.org/philosophy/why-not-lgpl.html>.
778 
779 */
780 // File: contracts/PineLendingLibrary.sol
781 
782 
783 pragma solidity 0.8.3;
784 
785 library PineLendingLibrary {
786   struct LoanTerms {
787     uint256 loanStartBlock;
788     uint256 loanExpireTimestamp;
789     uint32 interestBPS1000000XBlock;
790     uint32 maxLTVBPS;
791     uint256 borrowedWei;
792     uint256 returnedWei;
793     uint256 accuredInterestWei;
794     uint256 repaidInterestWei;
795     address borrower;
796     }
797 
798   function outstanding(LoanTerms calldata loanTerms, uint txSpeedBlocks) public view returns (uint256) {
799     // do not lump the interest
800     if (loanTerms.borrowedWei <= loanTerms.returnedWei) return 0;
801     uint256 newAccuredInterestWei = ((block.number + txSpeedBlocks -
802         loanTerms.loanStartBlock) *
803         (loanTerms.borrowedWei - loanTerms.returnedWei) *
804         loanTerms.interestBPS1000000XBlock) / 10000000000;
805     return
806         (loanTerms.borrowedWei - loanTerms.returnedWei) +
807         (loanTerms.accuredInterestWei -
808             loanTerms.repaidInterestWei) +
809         newAccuredInterestWei;
810   }
811 
812   function outstanding(LoanTerms calldata loanTerms) public view returns (uint256) {
813     return outstanding(loanTerms, 0);
814   }
815 
816   function nftHasLoan(LoanTerms memory loanTerms) public pure returns (bool) {
817       return loanTerms.borrowedWei > loanTerms.returnedWei;
818   }
819 
820 
821   function isUnHealthyLoan(LoanTerms calldata loanTerms)
822       public
823       view
824       returns (bool, uint32)
825   {
826       require(nftHasLoan(loanTerms), "nft does not have active loan");
827       bool isExpired = block.timestamp > loanTerms.loanExpireTimestamp &&
828           outstanding(loanTerms) > 0;
829       return (isExpired, 0);
830   }
831 
832   event LoanInitiated(
833       address indexed user,
834       address indexed erc721,
835       uint256 indexed nftID,
836       LoanTerms loan
837   );
838   event LoanTermsChanged(
839       address indexed user,
840       address indexed erc721,
841       uint256 indexed nftID,
842       LoanTerms oldTerms,
843       LoanTerms newTerms
844   );
845   event Liquidation(
846       address indexed user,
847       address indexed erc721,
848       uint256 indexed nftID,
849       uint256 liquidated_at,
850       address liquidator
851   );
852 }
853 // File: contracts/interfaces/IFlashLoanReceiver.sol
854 
855 pragma solidity 0.8.3;
856 
857 /**
858 * @title IFlashLoanReceiver interface
859 * @notice Interface for the Aave fee IFlashLoanReceiver.
860 * @author Aave
861 * @dev implement this interface to develop a flashloan-compatible flashLoanReceiver contract
862 **/
863 interface IFlashLoanReceiver {
864 
865     function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external;
866 }
867 // File: contracts/interfaces/ICloneFactory02.sol
868 
869 pragma solidity 0.8.3;
870 
871 /*
872 The MIT License (MIT)
873 Copyright (c) 2018 Murray Software, LLC.
874 Permission is hereby granted, free of charge, to any person obtaining
875 a copy of this software and associated documentation files (the
876 "Software"), to deal in the Software without restriction, including
877 without limitation the rights to use, copy, modify, merge, publish,
878 distribute, sublicense, and/or sell copies of the Software, and to
879 permit persons to whom the Software is furnished to do so, subject to
880 the following conditions:
881 The above copyright notice and this permission notice shall be included
882 in all copies or substantial portions of the Software.
883 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
884 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
885 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
886 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
887 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
888 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
889 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
890 */
891 //solhint-disable max-line-length
892 //solhint-disable no-inline-assembly
893 interface ICloneFactory02 {
894 
895   function createClone(address target) external returns (address result);
896   function targets(address target) external returns (bool result);
897   function genuineClone(address target) external returns (bool result);
898 
899   function toggleWhitelistedTarget(address target) external;
900   
901 }
902 // File: contracts/interfaces/IControlPlane01.sol
903 
904 /**
905   * ControlPlane01.sol
906   * Registers the current global params
907  */
908 pragma solidity 0.8.3;
909 
910 interface IControlPlane01 {
911 
912 
913   function whitelistedIntermediaries(address target) external returns (bool result);
914   function whitelistedFactory() external returns (address result);
915   function feeBps() external returns (uint32 result);
916 }
917 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
918 
919 
920 
921 pragma solidity ^0.8.0;
922 
923 /**
924  * @title ERC721 token receiver interface
925  * @dev Interface for any contract that wants to support safeTransfers
926  * from ERC721 asset contracts.
927  */
928 interface IERC721Receiver {
929     /**
930      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
931      * by `operator` from `from`, this function is called.
932      *
933      * It must return its Solidity selector to confirm the token transfer.
934      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
935      *
936      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
937      */
938     function onERC721Received(
939         address operator,
940         address from,
941         uint256 tokenId,
942         bytes calldata data
943     ) external returns (bytes4);
944 }
945 
946 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
947 
948 
949 
950 pragma solidity ^0.8.0;
951 
952 /**
953  * @dev Interface of the ERC165 standard, as defined in the
954  * https://eips.ethereum.org/EIPS/eip-165[EIP].
955  *
956  * Implementers can declare support of contract interfaces, which can then be
957  * queried by others ({ERC165Checker}).
958  *
959  * For an implementation, see {ERC165}.
960  */
961 interface IERC165 {
962     /**
963      * @dev Returns true if this contract implements the interface defined by
964      * `interfaceId`. See the corresponding
965      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
966      * to learn more about how these ids are created.
967      *
968      * This function call must use less than 30 000 gas.
969      */
970     function supportsInterface(bytes4 interfaceId) external view returns (bool);
971 }
972 
973 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
974 
975 
976 
977 pragma solidity ^0.8.0;
978 
979 
980 /**
981  * @dev Implementation of the {IERC165} interface.
982  *
983  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
984  * for the additional interface id that will be supported. For example:
985  *
986  * ```solidity
987  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
988  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
989  * }
990  * ```
991  *
992  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
993  */
994 abstract contract ERC165 is IERC165 {
995     /**
996      * @dev See {IERC165-supportsInterface}.
997      */
998     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
999         return interfaceId == type(IERC165).interfaceId;
1000     }
1001 }
1002 
1003 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1004 
1005 
1006 
1007 pragma solidity ^0.8.0;
1008 
1009 
1010 /**
1011  * @dev _Available since v3.1._
1012  */
1013 interface IERC1155Receiver is IERC165 {
1014     /**
1015         @dev Handles the receipt of a single ERC1155 token type. This function is
1016         called at the end of a `safeTransferFrom` after the balance has been updated.
1017         To accept the transfer, this must return
1018         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1019         (i.e. 0xf23a6e61, or its own function selector).
1020         @param operator The address which initiated the transfer (i.e. msg.sender)
1021         @param from The address which previously owned the token
1022         @param id The ID of the token being transferred
1023         @param value The amount of tokens being transferred
1024         @param data Additional data with no specified format
1025         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1026     */
1027     function onERC1155Received(
1028         address operator,
1029         address from,
1030         uint256 id,
1031         uint256 value,
1032         bytes calldata data
1033     ) external returns (bytes4);
1034 
1035     /**
1036         @dev Handles the receipt of a multiple ERC1155 token types. This function
1037         is called at the end of a `safeBatchTransferFrom` after the balances have
1038         been updated. To accept the transfer(s), this must return
1039         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1040         (i.e. 0xbc197c81, or its own function selector).
1041         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1042         @param from The address which previously owned the token
1043         @param ids An array containing ids of each token being transferred (order and length must match values array)
1044         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1045         @param data Additional data with no specified format
1046         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1047     */
1048     function onERC1155BatchReceived(
1049         address operator,
1050         address from,
1051         uint256[] calldata ids,
1052         uint256[] calldata values,
1053         bytes calldata data
1054     ) external returns (bytes4);
1055 }
1056 
1057 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol
1058 
1059 
1060 
1061 pragma solidity ^0.8.0;
1062 
1063 
1064 
1065 /**
1066  * @dev _Available since v3.1._
1067  */
1068 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
1069     /**
1070      * @dev See {IERC165-supportsInterface}.
1071      */
1072     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1073         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
1074     }
1075 }
1076 
1077 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol
1078 
1079 
1080 
1081 pragma solidity ^0.8.0;
1082 
1083 
1084 /**
1085  * @dev _Available since v3.1._
1086  */
1087 contract ERC1155Holder is ERC1155Receiver {
1088     function onERC1155Received(
1089         address,
1090         address,
1091         uint256,
1092         uint256,
1093         bytes memory
1094     ) public virtual override returns (bytes4) {
1095         return this.onERC1155Received.selector;
1096     }
1097 
1098     function onERC1155BatchReceived(
1099         address,
1100         address,
1101         uint256[] memory,
1102         uint256[] memory,
1103         bytes memory
1104     ) public virtual override returns (bytes4) {
1105         return this.onERC1155BatchReceived.selector;
1106     }
1107 }
1108 
1109 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1110 
1111 
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 
1116 /**
1117  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1118  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1119  *
1120  * _Available since v3.1._
1121  */
1122 interface IERC1155 is IERC165 {
1123     /**
1124      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1125      */
1126     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1127 
1128     /**
1129      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1130      * transfers.
1131      */
1132     event TransferBatch(
1133         address indexed operator,
1134         address indexed from,
1135         address indexed to,
1136         uint256[] ids,
1137         uint256[] values
1138     );
1139 
1140     /**
1141      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1142      * `approved`.
1143      */
1144     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1145 
1146     /**
1147      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1148      *
1149      * If an {URI} event was emitted for `id`, the standard
1150      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1151      * returned by {IERC1155MetadataURI-uri}.
1152      */
1153     event URI(string value, uint256 indexed id);
1154 
1155     /**
1156      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1157      *
1158      * Requirements:
1159      *
1160      * - `account` cannot be the zero address.
1161      */
1162     function balanceOf(address account, uint256 id) external view returns (uint256);
1163 
1164     /**
1165      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1166      *
1167      * Requirements:
1168      *
1169      * - `accounts` and `ids` must have the same length.
1170      */
1171     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1172         external
1173         view
1174         returns (uint256[] memory);
1175 
1176     /**
1177      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1178      *
1179      * Emits an {ApprovalForAll} event.
1180      *
1181      * Requirements:
1182      *
1183      * - `operator` cannot be the caller.
1184      */
1185     function setApprovalForAll(address operator, bool approved) external;
1186 
1187     /**
1188      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1189      *
1190      * See {setApprovalForAll}.
1191      */
1192     function isApprovedForAll(address account, address operator) external view returns (bool);
1193 
1194     /**
1195      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1196      *
1197      * Emits a {TransferSingle} event.
1198      *
1199      * Requirements:
1200      *
1201      * - `to` cannot be the zero address.
1202      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1203      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1204      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1205      * acceptance magic value.
1206      */
1207     function safeTransferFrom(
1208         address from,
1209         address to,
1210         uint256 id,
1211         uint256 amount,
1212         bytes calldata data
1213     ) external;
1214 
1215     /**
1216      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1217      *
1218      * Emits a {TransferBatch} event.
1219      *
1220      * Requirements:
1221      *
1222      * - `ids` and `amounts` must have the same length.
1223      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1224      * acceptance magic value.
1225      */
1226     function safeBatchTransferFrom(
1227         address from,
1228         address to,
1229         uint256[] calldata ids,
1230         uint256[] calldata amounts,
1231         bytes calldata data
1232     ) external;
1233 }
1234 
1235 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1236 
1237 
1238 
1239 pragma solidity ^0.8.0;
1240 
1241 
1242 /**
1243  * @dev Required interface of an ERC721 compliant contract.
1244  */
1245 interface IERC721 is IERC165 {
1246     /**
1247      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1248      */
1249     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1250 
1251     /**
1252      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1253      */
1254     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1255 
1256     /**
1257      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1258      */
1259     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1260 
1261     /**
1262      * @dev Returns the number of tokens in ``owner``'s account.
1263      */
1264     function balanceOf(address owner) external view returns (uint256 balance);
1265 
1266     /**
1267      * @dev Returns the owner of the `tokenId` token.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      */
1273     function ownerOf(uint256 tokenId) external view returns (address owner);
1274 
1275     /**
1276      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1277      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1278      *
1279      * Requirements:
1280      *
1281      * - `from` cannot be the zero address.
1282      * - `to` cannot be the zero address.
1283      * - `tokenId` token must exist and be owned by `from`.
1284      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1285      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function safeTransferFrom(
1290         address from,
1291         address to,
1292         uint256 tokenId
1293     ) external;
1294 
1295     /**
1296      * @dev Transfers `tokenId` token from `from` to `to`.
1297      *
1298      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1299      *
1300      * Requirements:
1301      *
1302      * - `from` cannot be the zero address.
1303      * - `to` cannot be the zero address.
1304      * - `tokenId` token must be owned by `from`.
1305      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1306      *
1307      * Emits a {Transfer} event.
1308      */
1309     function transferFrom(
1310         address from,
1311         address to,
1312         uint256 tokenId
1313     ) external;
1314 
1315     /**
1316      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1317      * The approval is cleared when the token is transferred.
1318      *
1319      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1320      *
1321      * Requirements:
1322      *
1323      * - The caller must own the token or be an approved operator.
1324      * - `tokenId` must exist.
1325      *
1326      * Emits an {Approval} event.
1327      */
1328     function approve(address to, uint256 tokenId) external;
1329 
1330     /**
1331      * @dev Returns the account approved for `tokenId` token.
1332      *
1333      * Requirements:
1334      *
1335      * - `tokenId` must exist.
1336      */
1337     function getApproved(uint256 tokenId) external view returns (address operator);
1338 
1339     /**
1340      * @dev Approve or remove `operator` as an operator for the caller.
1341      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1342      *
1343      * Requirements:
1344      *
1345      * - The `operator` cannot be the caller.
1346      *
1347      * Emits an {ApprovalForAll} event.
1348      */
1349     function setApprovalForAll(address operator, bool _approved) external;
1350 
1351     /**
1352      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1353      *
1354      * See {setApprovalForAll}
1355      */
1356     function isApprovedForAll(address owner, address operator) external view returns (bool);
1357 
1358     /**
1359      * @dev Safely transfers `tokenId` token from `from` to `to`.
1360      *
1361      * Requirements:
1362      *
1363      * - `from` cannot be the zero address.
1364      * - `to` cannot be the zero address.
1365      * - `tokenId` token must exist and be owned by `from`.
1366      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1367      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1368      *
1369      * Emits a {Transfer} event.
1370      */
1371     function safeTransferFrom(
1372         address from,
1373         address to,
1374         uint256 tokenId,
1375         bytes calldata data
1376     ) external;
1377 }
1378 
1379 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
1380 
1381 
1382 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
1383 
1384 pragma solidity ^0.8.0;
1385 
1386 /**
1387  * @dev Collection of functions related to the address type
1388  */
1389 library AddressUpgradeable {
1390     /**
1391      * @dev Returns true if `account` is a contract.
1392      *
1393      * [IMPORTANT]
1394      * ====
1395      * It is unsafe to assume that an address for which this function returns
1396      * false is an externally-owned account (EOA) and not a contract.
1397      *
1398      * Among others, `isContract` will return false for the following
1399      * types of addresses:
1400      *
1401      *  - an externally-owned account
1402      *  - a contract in construction
1403      *  - an address where a contract will be created
1404      *  - an address where a contract lived, but was destroyed
1405      * ====
1406      */
1407     function isContract(address account) internal view returns (bool) {
1408         // This method relies on extcodesize, which returns 0 for contracts in
1409         // construction, since the code is only stored at the end of the
1410         // constructor execution.
1411 
1412         uint256 size;
1413         assembly {
1414             size := extcodesize(account)
1415         }
1416         return size > 0;
1417     }
1418 
1419     /**
1420      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1421      * `recipient`, forwarding all available gas and reverting on errors.
1422      *
1423      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1424      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1425      * imposed by `transfer`, making them unable to receive funds via
1426      * `transfer`. {sendValue} removes this limitation.
1427      *
1428      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1429      *
1430      * IMPORTANT: because control is transferred to `recipient`, care must be
1431      * taken to not create reentrancy vulnerabilities. Consider using
1432      * {ReentrancyGuard} or the
1433      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1434      */
1435     function sendValue(address payable recipient, uint256 amount) internal {
1436         require(address(this).balance >= amount, "Address: insufficient balance");
1437 
1438         (bool success, ) = recipient.call{value: amount}("");
1439         require(success, "Address: unable to send value, recipient may have reverted");
1440     }
1441 
1442     /**
1443      * @dev Performs a Solidity function call using a low level `call`. A
1444      * plain `call` is an unsafe replacement for a function call: use this
1445      * function instead.
1446      *
1447      * If `target` reverts with a revert reason, it is bubbled up by this
1448      * function (like regular Solidity function calls).
1449      *
1450      * Returns the raw returned data. To convert to the expected return value,
1451      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1452      *
1453      * Requirements:
1454      *
1455      * - `target` must be a contract.
1456      * - calling `target` with `data` must not revert.
1457      *
1458      * _Available since v3.1._
1459      */
1460     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1461         return functionCall(target, data, "Address: low-level call failed");
1462     }
1463 
1464     /**
1465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1466      * `errorMessage` as a fallback revert reason when `target` reverts.
1467      *
1468      * _Available since v3.1._
1469      */
1470     function functionCall(
1471         address target,
1472         bytes memory data,
1473         string memory errorMessage
1474     ) internal returns (bytes memory) {
1475         return functionCallWithValue(target, data, 0, errorMessage);
1476     }
1477 
1478     /**
1479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1480      * but also transferring `value` wei to `target`.
1481      *
1482      * Requirements:
1483      *
1484      * - the calling contract must have an ETH balance of at least `value`.
1485      * - the called Solidity function must be `payable`.
1486      *
1487      * _Available since v3.1._
1488      */
1489     function functionCallWithValue(
1490         address target,
1491         bytes memory data,
1492         uint256 value
1493     ) internal returns (bytes memory) {
1494         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1495     }
1496 
1497     /**
1498      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1499      * with `errorMessage` as a fallback revert reason when `target` reverts.
1500      *
1501      * _Available since v3.1._
1502      */
1503     function functionCallWithValue(
1504         address target,
1505         bytes memory data,
1506         uint256 value,
1507         string memory errorMessage
1508     ) internal returns (bytes memory) {
1509         require(address(this).balance >= value, "Address: insufficient balance for call");
1510         require(isContract(target), "Address: call to non-contract");
1511 
1512         (bool success, bytes memory returndata) = target.call{value: value}(data);
1513         return verifyCallResult(success, returndata, errorMessage);
1514     }
1515 
1516     /**
1517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1518      * but performing a static call.
1519      *
1520      * _Available since v3.3._
1521      */
1522     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1523         return functionStaticCall(target, data, "Address: low-level static call failed");
1524     }
1525 
1526     /**
1527      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1528      * but performing a static call.
1529      *
1530      * _Available since v3.3._
1531      */
1532     function functionStaticCall(
1533         address target,
1534         bytes memory data,
1535         string memory errorMessage
1536     ) internal view returns (bytes memory) {
1537         require(isContract(target), "Address: static call to non-contract");
1538 
1539         (bool success, bytes memory returndata) = target.staticcall(data);
1540         return verifyCallResult(success, returndata, errorMessage);
1541     }
1542 
1543     /**
1544      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1545      * revert reason using the provided one.
1546      *
1547      * _Available since v4.3._
1548      */
1549     function verifyCallResult(
1550         bool success,
1551         bytes memory returndata,
1552         string memory errorMessage
1553     ) internal pure returns (bytes memory) {
1554         if (success) {
1555             return returndata;
1556         } else {
1557             // Look for revert reason and bubble it up if present
1558             if (returndata.length > 0) {
1559                 // The easiest way to bubble the revert reason is using memory via assembly
1560 
1561                 assembly {
1562                     let returndata_size := mload(returndata)
1563                     revert(add(32, returndata), returndata_size)
1564                 }
1565             } else {
1566                 revert(errorMessage);
1567             }
1568         }
1569     }
1570 }
1571 
1572 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
1573 
1574 
1575 // OpenZeppelin Contracts v4.4.1 (proxy/utils/Initializable.sol)
1576 
1577 pragma solidity ^0.8.0;
1578 
1579 
1580 /**
1581  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
1582  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
1583  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
1584  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
1585  *
1586  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
1587  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
1588  *
1589  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
1590  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
1591  *
1592  * [CAUTION]
1593  * ====
1594  * Avoid leaving a contract uninitialized.
1595  *
1596  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
1597  * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
1598  * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
1599  *
1600  * [.hljs-theme-light.nopadding]
1601  * ```
1602  * /// @custom:oz-upgrades-unsafe-allow constructor
1603  * constructor() initializer {}
1604  * ```
1605  * ====
1606  */
1607 abstract contract Initializable {
1608     /**
1609      * @dev Indicates that the contract has been initialized.
1610      */
1611     bool private _initialized;
1612 
1613     /**
1614      * @dev Indicates that the contract is in the process of being initialized.
1615      */
1616     bool private _initializing;
1617 
1618     /**
1619      * @dev Modifier to protect an initializer function from being invoked twice.
1620      */
1621     modifier initializer() {
1622         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
1623         // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
1624         // contract may have been reentered.
1625         require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");
1626 
1627         bool isTopLevelCall = !_initializing;
1628         if (isTopLevelCall) {
1629             _initializing = true;
1630             _initialized = true;
1631         }
1632 
1633         _;
1634 
1635         if (isTopLevelCall) {
1636             _initializing = false;
1637         }
1638     }
1639 
1640     /**
1641      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
1642      * {initializer} modifier, directly or indirectly.
1643      */
1644     modifier onlyInitializing() {
1645         require(_initializing, "Initializable: contract is not initializing");
1646         _;
1647     }
1648 
1649     function _isConstructor() private view returns (bool) {
1650         return !AddressUpgradeable.isContract(address(this));
1651     }
1652 }
1653 
1654 // File: @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol
1655 
1656 
1657 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1658 
1659 pragma solidity ^0.8.0;
1660 
1661 
1662 /**
1663  * @dev Contract module that helps prevent reentrant calls to a function.
1664  *
1665  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1666  * available, which can be applied to functions to make sure there are no nested
1667  * (reentrant) calls to them.
1668  *
1669  * Note that because there is a single `nonReentrant` guard, functions marked as
1670  * `nonReentrant` may not call one another. This can be worked around by making
1671  * those functions `private`, and then adding `external` `nonReentrant` entry
1672  * points to them.
1673  *
1674  * TIP: If you would like to learn more about reentrancy and alternative ways
1675  * to protect against it, check out our blog post
1676  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1677  */
1678 abstract contract ReentrancyGuardUpgradeable is Initializable {
1679     // Booleans are more expensive than uint256 or any type that takes up a full
1680     // word because each write operation emits an extra SLOAD to first read the
1681     // slot's contents, replace the bits taken up by the boolean, and then write
1682     // back. This is the compiler's defense against contract upgrades and
1683     // pointer aliasing, and it cannot be disabled.
1684 
1685     // The values being non-zero value makes deployment a bit more expensive,
1686     // but in exchange the refund on every call to nonReentrant will be lower in
1687     // amount. Since refunds are capped to a percentage of the total
1688     // transaction's gas, it is best to keep them low in cases like this one, to
1689     // increase the likelihood of the full refund coming into effect.
1690     uint256 private constant _NOT_ENTERED = 1;
1691     uint256 private constant _ENTERED = 2;
1692 
1693     uint256 private _status;
1694 
1695     function __ReentrancyGuard_init() internal onlyInitializing {
1696         __ReentrancyGuard_init_unchained();
1697     }
1698 
1699     function __ReentrancyGuard_init_unchained() internal onlyInitializing {
1700         _status = _NOT_ENTERED;
1701     }
1702 
1703     /**
1704      * @dev Prevents a contract from calling itself, directly or indirectly.
1705      * Calling a `nonReentrant` function from another `nonReentrant`
1706      * function is not supported. It is possible to prevent this from happening
1707      * by making the `nonReentrant` function external, and making it call a
1708      * `private` function that does the actual work.
1709      */
1710     modifier nonReentrant() {
1711         // On the first call to nonReentrant, _notEntered will be true
1712         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1713 
1714         // Any calls to nonReentrant after this point will fail
1715         _status = _ENTERED;
1716 
1717         _;
1718 
1719         // By storing the original value once again, a refund is triggered (see
1720         // https://eips.ethereum.org/EIPS/eip-2200)
1721         _status = _NOT_ENTERED;
1722     }
1723     uint256[49] private __gap;
1724 }
1725 
1726 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
1727 
1728 
1729 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1730 
1731 pragma solidity ^0.8.0;
1732 
1733 
1734 /**
1735  * @dev Provides information about the current execution context, including the
1736  * sender of the transaction and its data. While these are generally available
1737  * via msg.sender and msg.data, they should not be accessed in such a direct
1738  * manner, since when dealing with meta-transactions the account sending and
1739  * paying for execution may not be the actual sender (as far as an application
1740  * is concerned).
1741  *
1742  * This contract is only required for intermediate, library-like contracts.
1743  */
1744 abstract contract ContextUpgradeable is Initializable {
1745     function __Context_init() internal onlyInitializing {
1746         __Context_init_unchained();
1747     }
1748 
1749     function __Context_init_unchained() internal onlyInitializing {
1750     }
1751     function _msgSender() internal view virtual returns (address) {
1752         return msg.sender;
1753     }
1754 
1755     function _msgData() internal view virtual returns (bytes calldata) {
1756         return msg.data;
1757     }
1758     uint256[50] private __gap;
1759 }
1760 
1761 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
1762 
1763 
1764 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1765 
1766 pragma solidity ^0.8.0;
1767 
1768 
1769 
1770 /**
1771  * @dev Contract module which provides a basic access control mechanism, where
1772  * there is an account (an owner) that can be granted exclusive access to
1773  * specific functions.
1774  *
1775  * By default, the owner account will be the one that deploys the contract. This
1776  * can later be changed with {transferOwnership}.
1777  *
1778  * This module is used through inheritance. It will make available the modifier
1779  * `onlyOwner`, which can be applied to your functions to restrict their use to
1780  * the owner.
1781  */
1782 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1783     address private _owner;
1784 
1785     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1786 
1787     /**
1788      * @dev Initializes the contract setting the deployer as the initial owner.
1789      */
1790     function __Ownable_init() internal onlyInitializing {
1791         __Context_init_unchained();
1792         __Ownable_init_unchained();
1793     }
1794 
1795     function __Ownable_init_unchained() internal onlyInitializing {
1796         _transferOwnership(_msgSender());
1797     }
1798 
1799     /**
1800      * @dev Returns the address of the current owner.
1801      */
1802     function owner() public view virtual returns (address) {
1803         return _owner;
1804     }
1805 
1806     /**
1807      * @dev Throws if called by any account other than the owner.
1808      */
1809     modifier onlyOwner() {
1810         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1811         _;
1812     }
1813 
1814     /**
1815      * @dev Leaves the contract without owner. It will not be possible to call
1816      * `onlyOwner` functions anymore. Can only be called by the current owner.
1817      *
1818      * NOTE: Renouncing ownership will leave the contract without an owner,
1819      * thereby removing any functionality that is only available to the owner.
1820      */
1821     function renounceOwnership() public virtual onlyOwner {
1822         _transferOwnership(address(0));
1823     }
1824 
1825     /**
1826      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1827      * Can only be called by the current owner.
1828      */
1829     function transferOwnership(address newOwner) public virtual onlyOwner {
1830         require(newOwner != address(0), "Ownable: new owner is the zero address");
1831         _transferOwnership(newOwner);
1832     }
1833 
1834     /**
1835      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1836      * Internal function without access restriction.
1837      */
1838     function _transferOwnership(address newOwner) internal virtual {
1839         address oldOwner = _owner;
1840         _owner = newOwner;
1841         emit OwnershipTransferred(oldOwner, newOwner);
1842     }
1843     uint256[49] private __gap;
1844 }
1845 
1846 // File: @openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol
1847 
1848 
1849 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1850 
1851 pragma solidity ^0.8.0;
1852 
1853 
1854 
1855 /**
1856  * @dev Contract module which allows children to implement an emergency stop
1857  * mechanism that can be triggered by an authorized account.
1858  *
1859  * This module is used through inheritance. It will make available the
1860  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1861  * the functions of your contract. Note that they will not be pausable by
1862  * simply including this module, only once the modifiers are put in place.
1863  */
1864 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
1865     /**
1866      * @dev Emitted when the pause is triggered by `account`.
1867      */
1868     event Paused(address account);
1869 
1870     /**
1871      * @dev Emitted when the pause is lifted by `account`.
1872      */
1873     event Unpaused(address account);
1874 
1875     bool private _paused;
1876 
1877     /**
1878      * @dev Initializes the contract in unpaused state.
1879      */
1880     function __Pausable_init() internal onlyInitializing {
1881         __Context_init_unchained();
1882         __Pausable_init_unchained();
1883     }
1884 
1885     function __Pausable_init_unchained() internal onlyInitializing {
1886         _paused = false;
1887     }
1888 
1889     /**
1890      * @dev Returns true if the contract is paused, and false otherwise.
1891      */
1892     function paused() public view virtual returns (bool) {
1893         return _paused;
1894     }
1895 
1896     /**
1897      * @dev Modifier to make a function callable only when the contract is not paused.
1898      *
1899      * Requirements:
1900      *
1901      * - The contract must not be paused.
1902      */
1903     modifier whenNotPaused() {
1904         require(!paused(), "Pausable: paused");
1905         _;
1906     }
1907 
1908     /**
1909      * @dev Modifier to make a function callable only when the contract is paused.
1910      *
1911      * Requirements:
1912      *
1913      * - The contract must be paused.
1914      */
1915     modifier whenPaused() {
1916         require(paused(), "Pausable: not paused");
1917         _;
1918     }
1919 
1920     /**
1921      * @dev Triggers stopped state.
1922      *
1923      * Requirements:
1924      *
1925      * - The contract must not be paused.
1926      */
1927     function _pause() internal virtual whenNotPaused {
1928         _paused = true;
1929         emit Paused(_msgSender());
1930     }
1931 
1932     /**
1933      * @dev Returns to normal state.
1934      *
1935      * Requirements:
1936      *
1937      * - The contract must be paused.
1938      */
1939     function _unpause() internal virtual whenPaused {
1940         _paused = false;
1941         emit Unpaused(_msgSender());
1942     }
1943     uint256[49] private __gap;
1944 }
1945 
1946 // File: contracts/VerifySignaturePool02.sol
1947 
1948 
1949 pragma solidity 0.8.3;
1950 
1951 /* Signature Verification
1952 
1953 How to Sign and Verify
1954 # Signing
1955 1. Create message to sign
1956 2. Hash the message
1957 3. Sign the hash (off chain, keep your private key secret)
1958 
1959 # Verify
1960 1. Recreate hash from the original message
1961 2. Recover signer from signature and hash
1962 3. Compare recovered signer to claimed signer
1963 */
1964 
1965 library VerifySignaturePool02 {
1966     /* 1. Unlock MetaMask account
1967     ethereum.enable()
1968     */
1969 
1970     /* 2. Get message hash to sign
1971     getMessageHash(
1972         0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,
1973         123,
1974         "coffee and donuts",
1975         1
1976     )
1977 
1978     hash = "0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd"
1979     */
1980     function getMessageHash(
1981         address nft,
1982         uint tokenID,
1983         uint valuation,
1984         uint expireAtBlock
1985     ) public pure returns (bytes32) {
1986         return keccak256(abi.encodePacked(nft, tokenID, valuation, expireAtBlock));
1987     }
1988 
1989     /* 3. Sign message hash
1990     # using browser
1991     account = "copy paste account of signer here"
1992     ethereum.request({ method: "personal_sign", params: [account, hash]}).then(console.log)
1993 
1994     # using web3
1995     web3.personal.sign(hash, web3.eth.defaultAccount, console.log)
1996 
1997     Signature will be different for different accounts
1998     0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
1999     */
2000     function getEthSignedMessageHash(bytes32 _messageHash)
2001         public
2002         pure
2003         returns (bytes32)
2004     {
2005         /*
2006         Signature is produced by signing a keccak256 hash with the following format:
2007         "\x19Ethereum Signed Message\n" + len(msg) + msg
2008         */
2009         return
2010             keccak256(
2011                 abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
2012             );
2013     }
2014 
2015     /* 4. Verify signature
2016     signer = 0xB273216C05A8c0D4F0a4Dd0d7Bae1D2EfFE636dd
2017     to = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
2018     amount = 123
2019     message = "coffee and donuts"
2020     nonce = 1
2021     signature =
2022         0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
2023     */
2024     function verify(
2025         address nft,
2026         uint tokenID,
2027         uint valuation,
2028         uint expireAtBlock,
2029         address _signer,
2030         bytes memory signature
2031     ) public pure returns (bool) {
2032         bytes32 messageHash = getMessageHash(nft, tokenID, valuation, expireAtBlock);
2033         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
2034 
2035         return recoverSigner(ethSignedMessageHash, signature) == _signer;
2036     }
2037 
2038     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
2039         internal
2040         pure
2041         returns (address)
2042     {
2043         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
2044 
2045         return ecrecover(_ethSignedMessageHash, v, r, s);
2046     }
2047 
2048     function splitSignature(bytes memory sig)
2049         internal
2050         pure
2051         returns (
2052             bytes32 r,
2053             bytes32 s,
2054             uint8 v
2055         )
2056     {
2057         require(sig.length == 65, "invalid signature length");
2058 
2059         assembly {
2060             /*
2061             First 32 bytes stores the length of the signature
2062 
2063             add(sig, 32) = pointer of sig + 32
2064             effectively, skips first 32 bytes of signature
2065 
2066             mload(p) loads next 32 bytes starting at the memory address p into memory
2067             */
2068 
2069             // first 32 bytes, after the length prefix
2070             r := mload(add(sig, 32))
2071             // second 32 bytes
2072             s := mload(add(sig, 64))
2073             // final byte (first byte of the next 32 bytes)
2074             v := byte(0, mload(add(sig, 96)))
2075         }
2076 
2077         // implicitly return (r, s, v)
2078     }
2079 }
2080 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2081 
2082 
2083 
2084 pragma solidity ^0.8.0;
2085 
2086 /**
2087  * @dev Interface of the ERC20 standard as defined in the EIP.
2088  */
2089 interface IERC20 {
2090     /**
2091      * @dev Returns the amount of tokens in existence.
2092      */
2093     function totalSupply() external view returns (uint256);
2094 
2095     /**
2096      * @dev Returns the amount of tokens owned by `account`.
2097      */
2098     function balanceOf(address account) external view returns (uint256);
2099 
2100     /**
2101      * @dev Moves `amount` tokens from the caller's account to `recipient`.
2102      *
2103      * Returns a boolean value indicating whether the operation succeeded.
2104      *
2105      * Emits a {Transfer} event.
2106      */
2107     function transfer(address recipient, uint256 amount) external returns (bool);
2108 
2109     /**
2110      * @dev Returns the remaining number of tokens that `spender` will be
2111      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2112      * zero by default.
2113      *
2114      * This value changes when {approve} or {transferFrom} are called.
2115      */
2116     function allowance(address owner, address spender) external view returns (uint256);
2117 
2118     /**
2119      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2120      *
2121      * Returns a boolean value indicating whether the operation succeeded.
2122      *
2123      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2124      * that someone may use both the old and the new allowance by unfortunate
2125      * transaction ordering. One possible solution to mitigate this race
2126      * condition is to first reduce the spender's allowance to 0 and set the
2127      * desired value afterwards:
2128      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2129      *
2130      * Emits an {Approval} event.
2131      */
2132     function approve(address spender, uint256 amount) external returns (bool);
2133 
2134     /**
2135      * @dev Moves `amount` tokens from `sender` to `recipient` using the
2136      * allowance mechanism. `amount` is then deducted from the caller's
2137      * allowance.
2138      *
2139      * Returns a boolean value indicating whether the operation succeeded.
2140      *
2141      * Emits a {Transfer} event.
2142      */
2143     function transferFrom(
2144         address sender,
2145         address recipient,
2146         uint256 amount
2147     ) external returns (bool);
2148 
2149     /**
2150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2151      * another (`to`).
2152      *
2153      * Note that `value` may be zero.
2154      */
2155     event Transfer(address indexed from, address indexed to, uint256 value);
2156 
2157     /**
2158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2159      * a call to {approve}. `value` is the new allowance.
2160      */
2161     event Approval(address indexed owner, address indexed spender, uint256 value);
2162 }
2163 
2164 // File: contracts/ERC721LendingPool02.sol
2165 
2166 
2167 pragma solidity 0.8.3;
2168 
2169 
2170 
2171 
2172 
2173 
2174 
2175 
2176 
2177 
2178 
2179 
2180 
2181 
2182 contract ERC721LendingPool02 is
2183     OwnableUpgradeable,
2184     IERC721Receiver,
2185     PausableUpgradeable,
2186     ReentrancyGuardUpgradeable,
2187     ERC1155Holder
2188 {
2189     function onERC721Received(
2190         address operator,
2191         address from,
2192         uint256 tokenId,
2193         bytes calldata data
2194     ) public pure override returns (bytes4) {
2195         return
2196             bytes4(
2197                 keccak256("onERC721Received(address,address,uint256,bytes)")
2198             );
2199     }
2200 
2201     /**
2202      * Pool Constants
2203      */
2204     address public _valuationSigner;
2205 
2206     address public _supportedCollection;
2207 
2208     address public _controlPlane;
2209 
2210     address public _fundSource;
2211 
2212     address public _supportedCurrency;
2213 
2214     struct PoolParams {
2215         uint32 interestBPS1000000XBlock;
2216         uint32 collateralFactorBPS;
2217     }
2218 
2219     mapping(uint256 => PoolParams) public durationSeconds_poolParam;
2220 
2221     mapping(uint256 => uint256) public blockLoanAmount;
2222     uint256 public blockLoanLimit;
2223 
2224     /**
2225      * Pool Setup
2226      */
2227 
2228     function initialize(
2229         address supportedCollection,
2230         address valuationSigner,
2231         address controlPlane,
2232         address supportedCurrency,
2233         address fundSource
2234     ) public initializer {
2235         __Ownable_init();
2236         __Pausable_init();
2237         __ReentrancyGuard_init();
2238         _supportedCollection = supportedCollection;
2239         _valuationSigner = valuationSigner;
2240         _controlPlane = controlPlane;
2241         _supportedCurrency = supportedCurrency;
2242         _fundSource = fundSource;
2243         blockLoanLimit = 200000000000000000000;
2244     }
2245 
2246     function setBlockLoanLimit(uint256 bll) public onlyOwner {
2247         blockLoanLimit = bll;
2248     }
2249 
2250     function setDurationParam(uint256 duration, PoolParams calldata ppm)
2251         public
2252         onlyOwner
2253     {
2254         durationSeconds_poolParam[duration] = ppm;
2255         require(durationSeconds_poolParam[0].collateralFactorBPS == 0);
2256     }
2257 
2258     function pause() public onlyOwner {
2259         _pause();
2260     }
2261 
2262     function unpause() public onlyOwner {
2263         _unpause();
2264     }
2265 
2266     function updateBlockLoanAmount(uint256 loanAmount) internal {
2267         blockLoanAmount[block.number] += loanAmount;
2268         require(
2269             blockLoanAmount[block.number] < blockLoanLimit,
2270             "Amount exceed block limit"
2271         );
2272     }
2273 
2274     /**
2275      * Storage and Events
2276      */
2277 
2278     mapping(uint256 => PineLendingLibrary.LoanTerms) public _loans;
2279 
2280     /**
2281      * Loan origination
2282      */
2283     function flashLoan(
2284         address payable _receiver,
2285         address _reserve,
2286         uint256 _amount,
2287         bytes memory _params
2288     ) external nonReentrant {
2289         //check that the reserve has enough available liquidity
2290         uint256 availableLiquidityBefore = _reserve == address(0)
2291             ? address(this).balance
2292             : IERC20(_reserve).balanceOf(_fundSource);
2293         require(
2294             availableLiquidityBefore >= _amount,
2295             "There is not enough liquidity available to borrow"
2296         );
2297 
2298         uint256 lenderFeeBips = durationSeconds_poolParam[0]
2299             .interestBPS1000000XBlock;
2300         //calculate amount fee
2301         uint256 amountFee = (_amount * (lenderFeeBips)) / (10000000000);
2302 
2303         //get the FlashLoanReceiver instance
2304         IFlashLoanReceiver receiver = IFlashLoanReceiver(_receiver);
2305 
2306         //transfer funds to the receiver
2307         if (_reserve == address(0)) {
2308             (bool success, ) = _receiver.call{value: _amount}("");
2309             require(success, "Flash loan: cannot send ether");
2310         } else {
2311             IERC20(_reserve).transferFrom(_fundSource, _receiver, _amount);
2312         }
2313 
2314         //execute action of the receiver
2315         receiver.executeOperation(_reserve, _amount, amountFee, _params);
2316 
2317         //check that the actual balance of the core contract includes the returned amount
2318         uint256 availableLiquidityAfter = _reserve == address(0)
2319             ? address(this).balance
2320             : IERC20(_reserve).balanceOf(_fundSource);
2321 
2322         require(
2323             availableLiquidityAfter == availableLiquidityBefore + (amountFee),
2324             "The actual balance of the protocol is inconsistent"
2325         );
2326     }
2327 
2328     function borrow(
2329         uint256[5] calldata x,
2330         bytes memory signature,
2331         bool proxy,
2332         address pineWallet
2333     ) external nonReentrant whenNotPaused returns (bool) {
2334         //valuation = x[0]
2335         //nftID = x[1]
2336         //uint256 loanDurationSeconds = x[2];
2337         //uint256 expireAtBlock = x[3];
2338         //uint256 borrowedAmount = x[4];
2339         require(
2340             VerifySignaturePool02.verify(
2341                 _supportedCollection,
2342                 x[1],
2343                 x[0],
2344                 x[3],
2345                 _valuationSigner,
2346                 signature
2347             ),
2348             "SignatureVerifier: fake valuation provided!"
2349         );
2350         require(
2351             IControlPlane01(_controlPlane).whitelistedIntermediaries(
2352                 msg.sender
2353             ) || msg.sender == tx.origin,
2354             "Phishing!"
2355         );
2356         address contextUser = proxy ? tx.origin : msg.sender;
2357         require(
2358             !PineLendingLibrary.nftHasLoan(_loans[x[1]]),
2359             "NFT already has loan!"
2360         );
2361         uint32 maxLTVBPS = durationSeconds_poolParam[x[2]].collateralFactorBPS;
2362         require(maxLTVBPS > 0, "Duration not supported");
2363 
2364         uint256 pineMirrorID = uint256(
2365             keccak256(abi.encodePacked(_supportedCollection, x[1]))
2366         );
2367 
2368         if (pineWallet == (address(0))) {
2369             require(
2370                 IERC721(_supportedCollection).ownerOf(x[1]) == contextUser,
2371                 "Stealer1!"
2372             );
2373         } else {
2374             require(
2375                 ICloneFactory02(
2376                     IControlPlane01(_controlPlane).whitelistedFactory()
2377                 ).genuineClone(pineWallet),
2378                 "Scammer!"
2379             );
2380             require(
2381                 IERC721(pineWallet).ownerOf(pineMirrorID) == contextUser,
2382                 "Stealer2!"
2383             );
2384         }
2385 
2386         require(block.number < x[3], "Valuation expired");
2387         require(
2388             x[4] <= (x[0] * maxLTVBPS) / 10_000,
2389             "Can't borrow more than max LTV"
2390         );
2391         require(
2392             x[4] < IERC20(_supportedCurrency).balanceOf(_fundSource),
2393             "not enough money"
2394         );
2395 
2396         uint32 protocolFeeBips = IControlPlane01(_controlPlane).feeBps();
2397         uint256 protocolFee = (x[4] * (protocolFeeBips)) / (10000);
2398 
2399         updateBlockLoanAmount(x[4]);
2400 
2401         IERC20(_supportedCurrency).transferFrom(
2402             _fundSource,
2403             msg.sender,
2404             x[4] - protocolFee
2405         );
2406         IERC20(_supportedCurrency).transferFrom(
2407             _fundSource,
2408             _controlPlane,
2409             protocolFee
2410         );
2411         _loans[x[1]] = PineLendingLibrary.LoanTerms(
2412             block.number,
2413             block.timestamp + x[2],
2414             durationSeconds_poolParam[x[2]].interestBPS1000000XBlock,
2415             maxLTVBPS,
2416             x[4],
2417             0,
2418             0,
2419             0,
2420             contextUser
2421         );
2422 
2423         if (pineWallet == (address(0))) {
2424             IERC721(_supportedCollection).transferFrom(
2425                 contextUser,
2426                 address(this),
2427                 x[1]
2428             );
2429         } else {
2430             IERC721(pineWallet).transferFrom(
2431                 contextUser,
2432                 address(this),
2433                 pineMirrorID
2434             );
2435         }
2436 
2437         emit PineLendingLibrary.LoanInitiated(
2438             contextUser,
2439             _supportedCollection,
2440             x[1],
2441             _loans[x[1]]
2442         );
2443         return true;
2444     }
2445 
2446     /**
2447      * Repay
2448      */
2449 
2450     // repay change loan terms, renew loan start, fix interest to borrowed amount, dont renew loan expiry
2451     function repay(
2452         uint256 nftID,
2453         uint256 repayAmount,
2454         address pineWallet
2455     ) external nonReentrant whenNotPaused returns (bool) {
2456         uint256 pineMirrorID = uint256(
2457             keccak256(abi.encodePacked(_supportedCollection, nftID))
2458         );
2459         require(
2460             PineLendingLibrary.nftHasLoan(_loans[nftID]),
2461             "NFT does not have active loan"
2462         );
2463         require(
2464             IERC20(_supportedCurrency).transferFrom(
2465                 msg.sender,
2466                 address(this),
2467                 repayAmount
2468             ),
2469             "fund transfer unsuccessful"
2470         );
2471         PineLendingLibrary.LoanTerms memory oldLoanTerms = _loans[nftID];
2472 
2473         if (repayAmount >= PineLendingLibrary.outstanding(_loans[nftID])) {
2474             require(
2475                 IERC20(_supportedCurrency).transfer(
2476                     msg.sender,
2477                     repayAmount - PineLendingLibrary.outstanding(_loans[nftID])
2478                 ),
2479                 "exceed amount transfer unsuccessful"
2480             );
2481             repayAmount = PineLendingLibrary.outstanding(_loans[nftID]);
2482             _loans[nftID].returnedWei = _loans[nftID].borrowedWei;
2483             if (pineWallet == address(0)) {
2484                 IERC721(_supportedCollection).transferFrom(
2485                     address(this),
2486                     _loans[nftID].borrower,
2487                     nftID
2488                 );
2489             } else {
2490                 require(
2491                     ICloneFactory02(
2492                         IControlPlane01(_controlPlane).whitelistedFactory()
2493                     ).genuineClone(pineWallet),
2494                     "Scammer!"
2495                 );
2496                 IERC721(pineWallet).transferFrom(
2497                     address(this),
2498                     _loans[nftID].borrower,
2499                     pineMirrorID
2500                 );
2501             }
2502             clearLoanTerms(nftID);
2503         } else {
2504             // lump in interest
2505             _loans[nftID].accuredInterestWei +=
2506                 ((block.number - _loans[nftID].loanStartBlock) *
2507                     (_loans[nftID].borrowedWei - _loans[nftID].returnedWei) *
2508                     _loans[nftID].interestBPS1000000XBlock) /
2509                 10000000000;
2510             uint256 outstandingInterest = _loans[nftID].accuredInterestWei -
2511                 _loans[nftID].repaidInterestWei;
2512             if (repayAmount > outstandingInterest) {
2513                 _loans[nftID].repaidInterestWei = _loans[nftID]
2514                     .accuredInterestWei;
2515                 _loans[nftID].returnedWei += (repayAmount -
2516                     outstandingInterest);
2517             } else {
2518                 _loans[nftID].repaidInterestWei += repayAmount;
2519             }
2520             // restart interest calculation
2521             _loans[nftID].loanStartBlock = block.number;
2522         }
2523         require(
2524             IERC20(_supportedCurrency).transferFrom(
2525                 address(this),
2526                 _fundSource,
2527                 IERC20(_supportedCurrency).balanceOf(address(this))
2528             ),
2529             "fund transfer unsuccessful"
2530         );
2531         emit PineLendingLibrary.LoanTermsChanged(
2532             _loans[nftID].borrower,
2533             _supportedCollection,
2534             nftID,
2535             oldLoanTerms,
2536             _loans[nftID]
2537         );
2538         return true;
2539     }
2540 
2541     /**
2542      * Admin functions
2543      */
2544 
2545     function withdraw(uint256 amount) external onlyOwner {
2546         (bool success, ) = owner().call{value: amount}("");
2547         require(success, "cannot send ether");
2548     }
2549 
2550     function withdrawERC20(address currency, uint256 amount)
2551         external
2552         onlyOwner
2553     {
2554         IERC20(currency).transfer(owner(), amount);
2555     }
2556 
2557     function withdrawERC1155(address currency, uint256 id, uint256 amount)
2558         external
2559         onlyOwner
2560     {
2561         IERC1155(currency).safeTransferFrom(address(this), owner(), id, amount, "");
2562     }
2563 
2564     function withdrawERC721(
2565         address collection,
2566         uint256 nftID,
2567         address target,
2568         bool liquidation
2569     ) external {
2570         require(msg.sender == _controlPlane, "not control plane");
2571         if ((target == _supportedCollection) && liquidation) {
2572             PineLendingLibrary.LoanTerms memory lt = _loans[nftID];
2573             emit PineLendingLibrary.Liquidation(
2574                 lt.borrower,
2575                 _supportedCollection,
2576                 nftID,
2577                 block.timestamp,
2578                 tx.origin
2579             );
2580             clearLoanTerms(nftID);
2581         }
2582         IERC721(collection).transferFrom(address(this), target, nftID);
2583     }
2584 
2585     function clearLoanTerms(uint256 nftID) internal {
2586         _loans[nftID] = PineLendingLibrary.LoanTerms(
2587             0,
2588             0,
2589             0,
2590             0,
2591             0,
2592             0,
2593             0,
2594             0,
2595             address(0)
2596         );
2597     }
2598 }
2599 
2600 // File: @openzeppelin/contracts/utils/Context.sol
2601 
2602 
2603 
2604 pragma solidity ^0.8.0;
2605 
2606 /**
2607  * @dev Provides information about the current execution context, including the
2608  * sender of the transaction and its data. While these are generally available
2609  * via msg.sender and msg.data, they should not be accessed in such a direct
2610  * manner, since when dealing with meta-transactions the account sending and
2611  * paying for execution may not be the actual sender (as far as an application
2612  * is concerned).
2613  *
2614  * This contract is only required for intermediate, library-like contracts.
2615  */
2616 abstract contract Context {
2617     function _msgSender() internal view virtual returns (address) {
2618         return msg.sender;
2619     }
2620 
2621     function _msgData() internal view virtual returns (bytes calldata) {
2622         return msg.data;
2623     }
2624 }
2625 
2626 // File: @openzeppelin/contracts/access/Ownable.sol
2627 
2628 
2629 
2630 pragma solidity ^0.8.0;
2631 
2632 
2633 /**
2634  * @dev Contract module which provides a basic access control mechanism, where
2635  * there is an account (an owner) that can be granted exclusive access to
2636  * specific functions.
2637  *
2638  * By default, the owner account will be the one that deploys the contract. This
2639  * can later be changed with {transferOwnership}.
2640  *
2641  * This module is used through inheritance. It will make available the modifier
2642  * `onlyOwner`, which can be applied to your functions to restrict their use to
2643  * the owner.
2644  */
2645 abstract contract Ownable is Context {
2646     address private _owner;
2647 
2648     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2649 
2650     /**
2651      * @dev Initializes the contract setting the deployer as the initial owner.
2652      */
2653     constructor() {
2654         _setOwner(_msgSender());
2655     }
2656 
2657     /**
2658      * @dev Returns the address of the current owner.
2659      */
2660     function owner() public view virtual returns (address) {
2661         return _owner;
2662     }
2663 
2664     /**
2665      * @dev Throws if called by any account other than the owner.
2666      */
2667     modifier onlyOwner() {
2668         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2669         _;
2670     }
2671 
2672     /**
2673      * @dev Leaves the contract without owner. It will not be possible to call
2674      * `onlyOwner` functions anymore. Can only be called by the current owner.
2675      *
2676      * NOTE: Renouncing ownership will leave the contract without an owner,
2677      * thereby removing any functionality that is only available to the owner.
2678      */
2679     function renounceOwnership() public virtual onlyOwner {
2680         _setOwner(address(0));
2681     }
2682 
2683     /**
2684      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2685      * Can only be called by the current owner.
2686      */
2687     function transferOwnership(address newOwner) public virtual onlyOwner {
2688         require(newOwner != address(0), "Ownable: new owner is the zero address");
2689         _setOwner(newOwner);
2690     }
2691 
2692     function _setOwner(address newOwner) private {
2693         address oldOwner = _owner;
2694         _owner = newOwner;
2695         emit OwnershipTransferred(oldOwner, newOwner);
2696     }
2697 }
2698 
2699 // File: contracts/Router01.sol
2700 
2701 pragma solidity 0.8.3;
2702 
2703 
2704 
2705 
2706 
2707 contract Router01 is Ownable {
2708 
2709   address immutable WETHaddr;
2710   address payable immutable controlPlane;
2711 
2712   constructor (address w, address payable c) {
2713     WETHaddr = w;
2714     controlPlane = c;
2715   }
2716 
2717   uint fee = 0.01 ether;
2718 
2719   function setFee(uint f) public onlyOwner {
2720     fee = f;
2721   }
2722 
2723   function approvePool(address currency, address target, uint amount) public onlyOwner{
2724     IERC20(currency).approve(target, amount);
2725   }
2726 
2727   // function borrow(
2728   //   address payable target,
2729   //   uint256 valuation,
2730   //   uint256 nftID,
2731   //   uint256 loanDurationSeconds,
2732   //   uint256 expireAtBlock,
2733   //   uint256 borrowedWei,
2734   //   bytes memory signature,
2735   //   address pineWallet
2736   // ) public{
2737   //   address currency = ERC721LendingPool02(target)._supportedCurrency();
2738   //   ERC721LendingPool02(target).borrow([valuation, nftID, loanDurationSeconds, expireAtBlock, borrowedWei], signature, true, pineWallet);
2739   //   IERC20(currency).transfer(msg.sender, borrowedWei);
2740   // }
2741 
2742   function borrowETH(
2743     address payable target,
2744     uint256 valuation,
2745     uint256 nftID,
2746     uint256 loanDurationSeconds,
2747     uint256 expireAtBlock,
2748     uint256 borrowedWei,
2749     bytes memory signature,
2750     address pineWallet
2751   ) public{
2752     address currency = ERC721LendingPool02(target)._supportedCurrency();
2753     require(currency == WETHaddr, "only works for WETH");
2754     ERC721LendingPool02(target).borrow([valuation, nftID, loanDurationSeconds, expireAtBlock, borrowedWei], signature, true, pineWallet);
2755     WETH9(payable(currency)).withdraw(IERC20(currency).balanceOf(address(this)) - fee);
2756     (bool success, ) = msg.sender.call{value: address(this).balance}("");
2757     require(success, "cannot send ether");
2758     WETH9(payable(currency)).transfer(controlPlane, fee);
2759   }
2760 
2761   function repay(address payable target, uint256 nftID, uint256 repayAmount, address pineWallet) public {
2762     address currency = ERC721LendingPool02(target)._supportedCurrency();
2763     IERC20(currency).transferFrom(msg.sender, address(this), repayAmount);
2764     ERC721LendingPool02(target).repay(nftID, repayAmount, pineWallet);
2765     IERC20(currency).transferFrom(address(this), msg.sender, IERC20(currency).balanceOf(address(this)));
2766   }
2767 
2768   function repayETH(address payable target, uint nftID, address pineWallet) payable public {
2769     address currency = ERC721LendingPool02(target)._supportedCurrency();
2770     require(currency == WETHaddr, "only works for WETH");
2771     WETH9(payable(currency)).deposit{value: msg.value}();
2772     ERC721LendingPool02(target).repay(nftID, msg.value, pineWallet);
2773     WETH9(payable(currency)).withdraw(IERC20(currency).balanceOf(address(this)));
2774     (bool success, ) = msg.sender.call{value: address(this).balance}("");
2775     require(success, "cannot send ether");
2776   }
2777 
2778   receive() external payable {
2779         // React to receiving ether
2780   }
2781 
2782   function withdraw(uint256 amount) external onlyOwner {
2783       (bool success, ) = owner().call{value: amount}("");
2784       require(success, "cannot send ether");
2785   }
2786 
2787   function withdrawERC20(address currency, uint256 amount) external onlyOwner {
2788       IERC20(currency).transfer(owner(), amount);
2789   }
2790   
2791 }