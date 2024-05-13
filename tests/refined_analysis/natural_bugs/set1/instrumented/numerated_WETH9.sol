1 // Copyright (C) 2015, 2016, 2017 Dapphub
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 pragma solidity =0.6.6;
17 
18 contract WETH9 {
19     string public name     = "Wrapped Ether";
20     string public symbol   = "WETH";
21     uint8  public decimals = 18;
22 
23     event  Approval(address indexed src, address indexed guy, uint wad);
24     event  Transfer(address indexed src, address indexed dst, uint wad);
25     event  Deposit(address indexed dst, uint wad);
26     event  Withdrawal(address indexed src, uint wad);
27 
28     mapping (address => uint)                       public  balanceOf;
29     mapping (address => mapping (address => uint))  public  allowance;
30 
31     // function() public payable {
32     //     deposit();
33     // }
34     function deposit() public payable {
35         balanceOf[msg.sender] += msg.value;
36         emit Deposit(msg.sender, msg.value);
37     }
38     function withdraw(uint wad) public {
39         require(balanceOf[msg.sender] >= wad, "");
40         balanceOf[msg.sender] -= wad;
41         msg.sender.transfer(wad);
42         emit Withdrawal(msg.sender, wad);
43     }
44 
45     function totalSupply() public view returns (uint) {
46         return address(this).balance;
47     }
48 
49     function approve(address guy, uint wad) public returns (bool) {
50         allowance[msg.sender][guy] = wad;
51         emit Approval(msg.sender, guy, wad);
52         return true;
53     }
54 
55     function transfer(address dst, uint wad) public returns (bool) {
56         return transferFrom(msg.sender, dst, wad);
57     }
58 
59     function transferFrom(address src, address dst, uint wad)
60         public
61         returns (bool)
62     {
63         require(balanceOf[src] >= wad, "");
64 
65         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
66             require(allowance[src][msg.sender] >= wad, "");
67             allowance[src][msg.sender] -= wad;
68         }
69 
70         balanceOf[src] -= wad;
71         balanceOf[dst] += wad;
72 
73         emit Transfer(src, dst, wad);
74 
75         return true;
76     }
77 }
78 
79 
80 /*
81                     GNU GENERAL PUBLIC LICENSE
82                        Version 3, 29 June 2007
83 
84  Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
85  Everyone is permitted to copy and distribute verbatim copies
86  of this license document, but changing it is not allowed.
87 
88                             Preamble
89 
90   The GNU General Public License is a free, copyleft license for
91 software and other kinds of works.
92 
93   The licenses for most software and other practical works are designed
94 to take away your freedom to share and change the works.  By contrast,
95 the GNU General Public License is intended to guarantee your freedom to
96 share and change all versions of a program--to make sure it remains free
97 software for all its users.  We, the Free Software Foundation, use the
98 GNU General Public License for most of our software; it applies also to
99 any other work released this way by its authors.  You can apply it to
100 your programs, too.
101 
102   When we speak of free software, we are referring to freedom, not
103 price.  Our General Public Licenses are designed to make sure that you
104 have the freedom to distribute copies of free software (and charge for
105 them if you wish), that you receive source code or can get it if you
106 want it, that you can change the software or use pieces of it in new
107 free programs, and that you know you can do these things.
108 
109   To protect your rights, we need to prevent others from denying you
110 these rights or asking you to surrender the rights.  Therefore, you have
111 certain responsibilities if you distribute copies of the software, or if
112 you modify it: responsibilities to respect the freedom of others.
113 
114   For example, if you distribute copies of such a program, whether
115 gratis or for a fee, you must pass on to the recipients the same
116 freedoms that you received.  You must make sure that they, too, receive
117 or can get the source code.  And you must show them these terms so they
118 know their rights.
119 
120   Developers that use the GNU GPL protect your rights with two steps:
121 (1) assert copyright on the software, and (2) offer you this License
122 giving you legal permission to copy, distribute and/or modify it.
123 
124   For the developers' and authors' protection, the GPL clearly explains
125 that there is no warranty for this free software.  For both users' and
126 authors' sake, the GPL requires that modified versions be marked as
127 changed, so that their problems will not be attributed erroneously to
128 authors of previous versions.
129 
130   Some devices are designed to deny users access to install or run
131 modified versions of the software inside them, although the manufacturer
132 can do so.  This is fundamentally incompatible with the aim of
133 protecting users' freedom to change the software.  The systematic
134 pattern of such abuse occurs in the area of products for individuals to
135 use, which is precisely where it is most unacceptable.  Therefore, we
136 have designed this version of the GPL to prohibit the practice for those
137 products.  If such problems arise substantially in other domains, we
138 stand ready to extend this provision to those domains in future versions
139 of the GPL, as needed to protect the freedom of users.
140 
141   Finally, every program is threatened constantly by software patents.
142 States should not allow patents to restrict development and use of
143 software on general-purpose computers, but in those that do, we wish to
144 avoid the special danger that patents applied to a free program could
145 make it effectively proprietary.  To prevent this, the GPL assures that
146 patents cannot be used to render the program non-free.
147 
148   The precise terms and conditions for copying, distribution and
149 modification follow.
150 
151                        TERMS AND CONDITIONS
152 
153   0. Definitions.
154 
155   "This License" refers to version 3 of the GNU General Public License.
156 
157   "Copyright" also means copyright-like laws that apply to other kinds of
158 works, such as semiconductor masks.
159 
160   "The Program" refers to any copyrightable work licensed under this
161 License.  Each licensee is addressed as "you".  "Licensees" and
162 "recipients" may be individuals or organizations.
163 
164   To "modify" a work means to copy from or adapt all or part of the work
165 in a fashion requiring copyright permission, other than the making of an
166 exact copy.  The resulting work is called a "modified version" of the
167 earlier work or a work "based on" the earlier work.
168 
169   A "covered work" means either the unmodified Program or a work based
170 on the Program.
171 
172   To "propagate" a work means to do anything with it that, without
173 permission, would make you directly or secondarily liable for
174 infringement under applicable copyright law, except executing it on a
175 computer or modifying a private copy.  Propagation includes copying,
176 distribution (with or without modification), making available to the
177 public, and in some countries other activities as well.
178 
179   To "convey" a work means any kind of propagation that enables other
180 parties to make or receive copies.  Mere interaction with a user through
181 a computer network, with no transfer of a copy, is not conveying.
182 
183   An interactive user interface displays "Appropriate Legal Notices"
184 to the extent that it includes a convenient and prominently visible
185 feature that (1) displays an appropriate copyright notice, and (2)
186 tells the user that there is no warranty for the work (except to the
187 extent that warranties are provided), that licensees may convey the
188 work under this License, and how to view a copy of this License.  If
189 the interface presents a list of user commands or options, such as a
190 menu, a prominent item in the list meets this criterion.
191 
192   1. Source Code.
193 
194   The "source code" for a work means the preferred form of the work
195 for making modifications to it.  "Object code" means any non-source
196 form of a work.
197 
198   A "Standard Interface" means an interface that either is an official
199 standard defined by a recognized standards body, or, in the case of
200 interfaces specified for a particular programming language, one that
201 is widely used among developers working in that language.
202 
203   The "System Libraries" of an executable work include anything, other
204 than the work as a whole, that (a) is included in the normal form of
205 packaging a Major Component, but which is not part of that Major
206 Component, and (b) serves only to enable use of the work with that
207 Major Component, or to implement a Standard Interface for which an
208 implementation is available to the public in source code form.  A
209 "Major Component", in this context, means a major essential component
210 (kernel, window system, and so on) of the specific operating system
211 (if any) on which the executable work runs, or a compiler used to
212 produce the work, or an object code interpreter used to run it.
213 
214   The "Corresponding Source" for a work in object code form means all
215 the source code needed to generate, install, and (for an executable
216 work) run the object code and to modify the work, including scripts to
217 control those activities.  However, it does not include the work's
218 System Libraries, or general-purpose tools or generally available free
219 programs which are used unmodified in performing those activities but
220 which are not part of the work.  For example, Corresponding Source
221 includes interface definition files associated with source files for
222 the work, and the source code for shared libraries and dynamically
223 linked subprograms that the work is specifically designed to require,
224 such as by intimate data communication or control flow between those
225 subprograms and other parts of the work.
226 
227   The Corresponding Source need not include anything that users
228 can regenerate automatically from other parts of the Corresponding
229 Source.
230 
231   The Corresponding Source for a work in source code form is that
232 same work.
233 
234   2. Basic Permissions.
235 
236   All rights granted under this License are granted for the term of
237 copyright on the Program, and are irrevocable provided the stated
238 conditions are met.  This License explicitly affirms your unlimited
239 permission to run the unmodified Program.  The output from running a
240 covered work is covered by this License only if the output, given its
241 content, constitutes a covered work.  This License acknowledges your
242 rights of fair use or other equivalent, as provided by copyright law.
243 
244   You may make, run and propagate covered works that you do not
245 convey, without conditions so long as your license otherwise remains
246 in force.  You may convey covered works to others for the sole purpose
247 of having them make modifications exclusively for you, or provide you
248 with facilities for running those works, provided that you comply with
249 the terms of this License in conveying all material for which you do
250 not control copyright.  Those thus making or running the covered works
251 for you must do so exclusively on your behalf, under your direction
252 and control, on terms that prohibit them from making any copies of
253 your copyrighted material outside their relationship with you.
254 
255   Conveying under any other circumstances is permitted solely under
256 the conditions stated below.  Sublicensing is not allowed; section 10
257 makes it unnecessary.
258 
259   3. Protecting Users' Legal Rights From Anti-Circumvention Law.
260 
261   No covered work shall be deemed part of an effective technological
262 measure under any applicable law fulfilling obligations under article
263 11 of the WIPO copyright treaty adopted on 20 December 1996, or
264 similar laws prohibiting or restricting circumvention of such
265 measures.
266 
267   When you convey a covered work, you waive any legal power to forbid
268 circumvention of technological measures to the extent such circumvention
269 is effected by exercising rights under this License with respect to
270 the covered work, and you disclaim any intention to limit operation or
271 modification of the work as a means of enforcing, against the work's
272 users, your or third parties' legal rights to forbid circumvention of
273 technological measures.
274 
275   4. Conveying Verbatim Copies.
276 
277   You may convey verbatim copies of the Program's source code as you
278 receive it, in any medium, provided that you conspicuously and
279 appropriately publish on each copy an appropriate copyright notice;
280 keep intact all notices stating that this License and any
281 non-permissive terms added in accord with section 7 apply to the code;
282 keep intact all notices of the absence of any warranty; and give all
283 recipients a copy of this License along with the Program.
284 
285   You may charge any price or no price for each copy that you convey,
286 and you may offer support or warranty protection for a fee.
287 
288   5. Conveying Modified Source Versions.
289 
290   You may convey a work based on the Program, or the modifications to
291 produce it from the Program, in the form of source code under the
292 terms of section 4, provided that you also meet all of these conditions:
293 
294     a) The work must carry prominent notices stating that you modified
295     it, and giving a relevant date.
296 
297     b) The work must carry prominent notices stating that it is
298     released under this License and any conditions added under section
299     7.  This requirement modifies the requirement in section 4 to
300     "keep intact all notices".
301 
302     c) You must license the entire work, as a whole, under this
303     License to anyone who comes into possession of a copy.  This
304     License will therefore apply, along with any applicable section 7
305     additional terms, to the whole of the work, and all its parts,
306     regardless of how they are packaged.  This License gives no
307     permission to license the work in any other way, but it does not
308     invalidate such permission if you have separately received it.
309 
310     d) If the work has interactive user interfaces, each must display
311     Appropriate Legal Notices; however, if the Program has interactive
312     interfaces that do not display Appropriate Legal Notices, your
313     work need not make them do so.
314 
315   A compilation of a covered work with other separate and independent
316 works, which are not by their nature extensions of the covered work,
317 and which are not combined with it such as to form a larger program,
318 in or on a volume of a storage or distribution medium, is called an
319 "aggregate" if the compilation and its resulting copyright are not
320 used to limit the access or legal rights of the compilation's users
321 beyond what the individual works permit.  Inclusion of a covered work
322 in an aggregate does not cause this License to apply to the other
323 parts of the aggregate.
324 
325   6. Conveying Non-Source Forms.
326 
327   You may convey a covered work in object code form under the terms
328 of sections 4 and 5, provided that you also convey the
329 machine-readable Corresponding Source under the terms of this License,
330 in one of these ways:
331 
332     a) Convey the object code in, or embodied in, a physical product
333     (including a physical distribution medium), accompanied by the
334     Corresponding Source fixed on a durable physical medium
335     customarily used for software interchange.
336 
337     b) Convey the object code in, or embodied in, a physical product
338     (including a physical distribution medium), accompanied by a
339     written offer, valid for at least three years and valid for as
340     long as you offer spare parts or customer support for that product
341     model, to give anyone who possesses the object code either (1) a
342     copy of the Corresponding Source for all the software in the
343     product that is covered by this License, on a durable physical
344     medium customarily used for software interchange, for a price no
345     more than your reasonable cost of physically performing this
346     conveying of source, or (2) access to copy the
347     Corresponding Source from a network server at no charge.
348 
349     c) Convey individual copies of the object code with a copy of the
350     written offer to provide the Corresponding Source.  This
351     alternative is allowed only occasionally and noncommercially, and
352     only if you received the object code with such an offer, in accord
353     with subsection 6b.
354 
355     d) Convey the object code by offering access from a designated
356     place (gratis or for a charge), and offer equivalent access to the
357     Corresponding Source in the same way through the same place at no
358     further charge.  You need not require recipients to copy the
359     Corresponding Source along with the object code.  If the place to
360     copy the object code is a network server, the Corresponding Source
361     may be on a different server (operated by you or a third party)
362     that supports equivalent copying facilities, provided you maintain
363     clear directions next to the object code saying where to find the
364     Corresponding Source.  Regardless of what server hosts the
365     Corresponding Source, you remain obligated to ensure that it is
366     available for as long as needed to satisfy these requirements.
367 
368     e) Convey the object code using peer-to-peer transmission, provided
369     you inform other peers where the object code and Corresponding
370     Source of the work are being offered to the general public at no
371     charge under subsection 6d.
372 
373   A separable portion of the object code, whose source code is excluded
374 from the Corresponding Source as a System Library, need not be
375 included in conveying the object code work.
376 
377   A "User Product" is either (1) a "consumer product", which means any
378 tangible personal property which is normally used for personal, family,
379 or household purposes, or (2) anything designed or sold for incorporation
380 into a dwelling.  In determining whether a product is a consumer product,
381 doubtful cases shall be resolved in favor of coverage.  For a particular
382 product received by a particular user, "normally used" refers to a
383 typical or common use of that class of product, regardless of the status
384 of the particular user or of the way in which the particular user
385 actually uses, or expects or is expected to use, the product.  A product
386 is a consumer product regardless of whether the product has substantial
387 commercial, industrial or non-consumer uses, unless such uses represent
388 the only significant mode of use of the product.
389 
390   "Installation Information" for a User Product means any methods,
391 procedures, authorization keys, or other information required to install
392 and execute modified versions of a covered work in that User Product from
393 a modified version of its Corresponding Source.  The information must
394 suffice to ensure that the continued functioning of the modified object
395 code is in no case prevented or interfered with solely because
396 modification has been made.
397 
398   If you convey an object code work under this section in, or with, or
399 specifically for use in, a User Product, and the conveying occurs as
400 part of a transaction in which the right of possession and use of the
401 User Product is transferred to the recipient in perpetuity or for a
402 fixed term (regardless of how the transaction is characterized), the
403 Corresponding Source conveyed under this section must be accompanied
404 by the Installation Information.  But this requirement does not apply
405 if neither you nor any third party retains the ability to install
406 modified object code on the User Product (for example, the work has
407 been installed in ROM).
408 
409   The requirement to provide Installation Information does not include a
410 requirement to continue to provide support service, warranty, or updates
411 for a work that has been modified or installed by the recipient, or for
412 the User Product in which it has been modified or installed.  Access to a
413 network may be denied when the modification itself materially and
414 adversely affects the operation of the network or violates the rules and
415 protocols for communication across the network.
416 
417   Corresponding Source conveyed, and Installation Information provided,
418 in accord with this section must be in a format that is publicly
419 documented (and with an implementation available to the public in
420 source code form), and must require no special password or key for
421 unpacking, reading or copying.
422 
423   7. Additional Terms.
424 
425   "Additional permissions" are terms that supplement the terms of this
426 License by making exceptions from one or more of its conditions.
427 Additional permissions that are applicable to the entire Program shall
428 be treated as though they were included in this License, to the extent
429 that they are valid under applicable law.  If additional permissions
430 apply only to part of the Program, that part may be used separately
431 under those permissions, but the entire Program remains governed by
432 this License without regard to the additional permissions.
433 
434   When you convey a copy of a covered work, you may at your option
435 remove any additional permissions from that copy, or from any part of
436 it.  (Additional permissions may be written to require their own
437 removal in certain cases when you modify the work.)  You may place
438 additional permissions on material, added by you to a covered work,
439 for which you have or can give appropriate copyright permission.
440 
441   Notwithstanding any other provision of this License, for material you
442 add to a covered work, you may (if authorized by the copyright holders of
443 that material) supplement the terms of this License with terms:
444 
445     a) Disclaiming warranty or limiting liability differently from the
446     terms of sections 15 and 16 of this License; or
447 
448     b) Requiring preservation of specified reasonable legal notices or
449     author attributions in that material or in the Appropriate Legal
450     Notices displayed by works containing it; or
451 
452     c) Prohibiting misrepresentation of the origin of that material, or
453     requiring that modified versions of such material be marked in
454     reasonable ways as different from the original version; or
455 
456     d) Limiting the use for publicity purposes of names of licensors or
457     authors of the material; or
458 
459     e) Declining to grant rights under trademark law for use of some
460     trade names, trademarks, or service marks; or
461 
462     f) Requiring indemnification of licensors and authors of that
463     material by anyone who conveys the material (or modified versions of
464     it) with contractual assumptions of liability to the recipient, for
465     any liability that these contractual assumptions directly impose on
466     those licensors and authors.
467 
468   All other non-permissive additional terms are considered "further
469 restrictions" within the meaning of section 10.  If the Program as you
470 received it, or any part of it, contains a notice stating that it is
471 governed by this License along with a term that is a further
472 restriction, you may remove that term.  If a license document contains
473 a further restriction but permits relicensing or conveying under this
474 License, you may add to a covered work material governed by the terms
475 of that license document, provided that the further restriction does
476 not survive such relicensing or conveying.
477 
478   If you add terms to a covered work in accord with this section, you
479 must place, in the relevant source files, a statement of the
480 additional terms that apply to those files, or a notice indicating
481 where to find the applicable terms.
482 
483   Additional terms, permissive or non-permissive, may be stated in the
484 form of a separately written license, or stated as exceptions;
485 the above requirements apply either way.
486 
487   8. Termination.
488 
489   You may not propagate or modify a covered work except as expressly
490 provided under this License.  Any attempt otherwise to propagate or
491 modify it is void, and will automatically terminate your rights under
492 this License (including any patent licenses granted under the third
493 paragraph of section 11).
494 
495   However, if you cease all violation of this License, then your
496 license from a particular copyright holder is reinstated (a)
497 provisionally, unless and until the copyright holder explicitly and
498 finally terminates your license, and (b) permanently, if the copyright
499 holder fails to notify you of the violation by some reasonable means
500 prior to 60 days after the cessation.
501 
502   Moreover, your license from a particular copyright holder is
503 reinstated permanently if the copyright holder notifies you of the
504 violation by some reasonable means, this is the first time you have
505 received notice of violation of this License (for any work) from that
506 copyright holder, and you cure the violation prior to 30 days after
507 your receipt of the notice.
508 
509   Termination of your rights under this section does not terminate the
510 licenses of parties who have received copies or rights from you under
511 this License.  If your rights have been terminated and not permanently
512 reinstated, you do not qualify to receive new licenses for the same
513 material under section 10.
514 
515   9. Acceptance Not Required for Having Copies.
516 
517   You are not required to accept this License in order to receive or
518 run a copy of the Program.  Ancillary propagation of a covered work
519 occurring solely as a consequence of using peer-to-peer transmission
520 to receive a copy likewise does not require acceptance.  However,
521 nothing other than this License grants you permission to propagate or
522 modify any covered work.  These actions infringe copyright if you do
523 not accept this License.  Therefore, by modifying or propagating a
524 covered work, you indicate your acceptance of this License to do so.
525 
526   10. Automatic Licensing of Downstream Recipients.
527 
528   Each time you convey a covered work, the recipient automatically
529 receives a license from the original licensors, to run, modify and
530 propagate that work, subject to this License.  You are not responsible
531 for enforcing compliance by third parties with this License.
532 
533   An "entity transaction" is a transaction transferring control of an
534 organization, or substantially all assets of one, or subdividing an
535 organization, or merging organizations.  If propagation of a covered
536 work results from an entity transaction, each party to that
537 transaction who receives a copy of the work also receives whatever
538 licenses to the work the party's predecessor in interest had or could
539 give under the previous paragraph, plus a right to possession of the
540 Corresponding Source of the work from the predecessor in interest, if
541 the predecessor has it or can get it with reasonable efforts.
542 
543   You may not impose any further restrictions on the exercise of the
544 rights granted or affirmed under this License.  For example, you may
545 not impose a license fee, royalty, or other charge for exercise of
546 rights granted under this License, and you may not initiate litigation
547 (including a cross-claim or counterclaim in a lawsuit) alleging that
548 any patent claim is infringed by making, using, selling, offering for
549 sale, or importing the Program or any portion of it.
550 
551   11. Patents.
552 
553   A "contributor" is a copyright holder who authorizes use under this
554 License of the Program or a work on which the Program is based.  The
555 work thus licensed is called the contributor's "contributor version".
556 
557   A contributor's "essential patent claims" are all patent claims
558 owned or controlled by the contributor, whether already acquired or
559 hereafter acquired, that would be infringed by some manner, permitted
560 by this License, of making, using, or selling its contributor version,
561 but do not include claims that would be infringed only as a
562 consequence of further modification of the contributor version.  For
563 purposes of this definition, "control" includes the right to grant
564 patent sublicenses in a manner consistent with the requirements of
565 this License.
566 
567   Each contributor grants you a non-exclusive, worldwide, royalty-free
568 patent license under the contributor's essential patent claims, to
569 make, use, sell, offer for sale, import and otherwise run, modify and
570 propagate the contents of its contributor version.
571 
572   In the following three paragraphs, a "patent license" is any express
573 agreement or commitment, however denominated, not to enforce a patent
574 (such as an express permission to practice a patent or covenant not to
575 sue for patent infringement).  To "grant" such a patent license to a
576 party means to make such an agreement or commitment not to enforce a
577 patent against the party.
578 
579   If you convey a covered work, knowingly relying on a patent license,
580 and the Corresponding Source of the work is not available for anyone
581 to copy, free of charge and under the terms of this License, through a
582 publicly available network server or other readily accessible means,
583 then you must either (1) cause the Corresponding Source to be so
584 available, or (2) arrange to deprive yourself of the benefit of the
585 patent license for this particular work, or (3) arrange, in a manner
586 consistent with the requirements of this License, to extend the patent
587 license to downstream recipients.  "Knowingly relying" means you have
588 actual knowledge that, but for the patent license, your conveying the
589 covered work in a country, or your recipient's use of the covered work
590 in a country, would infringe one or more identifiable patents in that
591 country that you have reason to believe are valid.
592 
593   If, pursuant to or in connection with a single transaction or
594 arrangement, you convey, or propagate by procuring conveyance of, a
595 covered work, and grant a patent license to some of the parties
596 receiving the covered work authorizing them to use, propagate, modify
597 or convey a specific copy of the covered work, then the patent license
598 you grant is automatically extended to all recipients of the covered
599 work and works based on it.
600 
601   A patent license is "discriminatory" if it does not include within
602 the scope of its coverage, prohibits the exercise of, or is
603 conditioned on the non-exercise of one or more of the rights that are
604 specifically granted under this License.  You may not convey a covered
605 work if you are a party to an arrangement with a third party that is
606 in the business of distributing software, under which you make payment
607 to the third party based on the extent of your activity of conveying
608 the work, and under which the third party grants, to any of the
609 parties who would receive the covered work from you, a discriminatory
610 patent license (a) in connection with copies of the covered work
611 conveyed by you (or copies made from those copies), or (b) primarily
612 for and in connection with specific products or compilations that
613 contain the covered work, unless you entered into that arrangement,
614 or that patent license was granted, prior to 28 March 2007.
615 
616   Nothing in this License shall be construed as excluding or limiting
617 any implied license or other defenses to infringement that may
618 otherwise be available to you under applicable patent law.
619 
620   12. No Surrender of Others' Freedom.
621 
622   If conditions are imposed on you (whether by court order, agreement or
623 otherwise) that contradict the conditions of this License, they do not
624 excuse you from the conditions of this License.  If you cannot convey a
625 covered work so as to satisfy simultaneously your obligations under this
626 License and any other pertinent obligations, then as a consequence you may
627 not convey it at all.  For example, if you agree to terms that obligate you
628 to collect a royalty for further conveying from those to whom you convey
629 the Program, the only way you could satisfy both those terms and this
630 License would be to refrain entirely from conveying the Program.
631 
632   13. Use with the GNU Affero General Public License.
633 
634   Notwithstanding any other provision of this License, you have
635 permission to link or combine any covered work with a work licensed
636 under version 3 of the GNU Affero General Public License into a single
637 combined work, and to convey the resulting work.  The terms of this
638 License will continue to apply to the part which is the covered work,
639 but the special requirements of the GNU Affero General Public License,
640 section 13, concerning interaction through a network will apply to the
641 combination as such.
642 
643   14. Revised Versions of this License.
644 
645   The Free Software Foundation may publish revised and/or new versions of
646 the GNU General Public License from time to time.  Such new versions will
647 be similar in spirit to the present version, but may differ in detail to
648 address new problems or concerns.
649 
650   Each version is given a distinguishing version number.  If the
651 Program specifies that a certain numbered version of the GNU General
652 Public License "or any later version" applies to it, you have the
653 option of following the terms and conditions either of that numbered
654 version or of any later version published by the Free Software
655 Foundation.  If the Program does not specify a version number of the
656 GNU General Public License, you may choose any version ever published
657 by the Free Software Foundation.
658 
659   If the Program specifies that a proxy can decide which future
660 versions of the GNU General Public License can be used, that proxy's
661 public statement of acceptance of a version permanently authorizes you
662 to choose that version for the Program.
663 
664   Later license versions may give you additional or different
665 permissions.  However, no additional obligations are imposed on any
666 author or copyright holder as a result of your choosing to follow a
667 later version.
668 
669   15. Disclaimer of Warranty.
670 
671   THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
672 APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
673 HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
674 OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
675 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
676 PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
677 IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
678 ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
679 
680   16. Limitation of Liability.
681 
682   IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
683 WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
684 THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
685 GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
686 USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
687 DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
688 PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
689 EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
690 SUCH DAMAGES.
691 
692   17. Interpretation of Sections 15 and 16.
693 
694   If the disclaimer of warranty and limitation of liability provided
695 above cannot be given local legal effect according to their terms,
696 reviewing courts shall apply local law that most closely approximates
697 an absolute waiver of all civil liability in connection with the
698 Program, unless a warranty or assumption of liability accompanies a
699 copy of the Program in return for a fee.
700 
701                      END OF TERMS AND CONDITIONS
702 
703             How to Apply These Terms to Your New Programs
704 
705   If you develop a new program, and you want it to be of the greatest
706 possible use to the public, the best way to achieve this is to make it
707 free software which everyone can redistribute and change under these terms.
708 
709   To do so, attach the following notices to the program.  It is safest
710 to attach them to the start of each source file to most effectively
711 state the exclusion of warranty; and each file should have at least
712 the "copyright" line and a pointer to where the full notice is found.
713 
714     <one line to give the program's name and a brief idea of what it does.>
715     Copyright (C) <year>  <name of author>
716 
717     This program is free software: you can redistribute it and/or modify
718     it under the terms of the GNU General Public License as published by
719     the Free Software Foundation, either version 3 of the License, or
720     (at your option) any later version.
721 
722     This program is distributed in the hope that it will be useful,
723     but WITHOUT ANY WARRANTY; without even the implied warranty of
724     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
725     GNU General Public License for more details.
726 
727     You should have received a copy of the GNU General Public License
728     along with this program.  If not, see <http://www.gnu.org/licenses/>.
729 
730 Also add information on how to contact you by electronic and paper mail.
731 
732   If the program does terminal interaction, make it output a short
733 notice like this when it starts in an interactive mode:
734 
735     <program>  Copyright (C) <year>  <name of author>
736     This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
737     This is free software, and you are welcome to redistribute it
738     under certain conditions; type `show c' for details.
739 
740 The hypothetical commands `show w' and `show c' should show the appropriate
741 parts of the General Public License.  Of course, your program's commands
742 might be different; for a GUI interface, you would use an "about box".
743 
744   You should also get your employer (if you work as a programmer) or school,
745 if any, to sign a "copyright disclaimer" for the program, if necessary.
746 For more information on this, and how to apply and follow the GNU GPL, see
747 <http://www.gnu.org/licenses/>.
748 
749   The GNU General Public License does not permit incorporating your program
750 into proprietary programs.  If your program is a subroutine library, you
751 may consider it more useful to permit linking proprietary applications with
752 the library.  If this is what you want to do, use the GNU Lesser General
753 Public License instead of this License.  But first, please read
754 <http://www.gnu.org/philosophy/why-not-lgpl.html>.
755 
756 */