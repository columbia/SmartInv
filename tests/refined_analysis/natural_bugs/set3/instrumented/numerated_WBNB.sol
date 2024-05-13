1 // SPDX-License-Identifier: MIT
2 
3 /**
4  *Submitted for verification at BscScan.com on 2020-09-03
5 */
6 
7 /**
8  *Submitted for verification at Bscscan.com on 2020-09-03
9 */
10 
11 pragma solidity >=0.4.18;
12 
13 contract WBNB {
14     string public name     = "Wrapped BNB";
15     string public symbol   = "WBNB";
16     uint8  public decimals = 18;
17 
18     event  Approval(address indexed src, address indexed guy, uint wad);
19     event  Transfer(address indexed src, address indexed dst, uint wad);
20     event  Deposit(address indexed dst, uint wad);
21     event  Withdrawal(address indexed src, uint wad);
22 
23     mapping (address => uint)                       public  balanceOf;
24     mapping (address => mapping (address => uint))  public  allowance;
25 
26     receive() external payable {
27         deposit();
28     }
29     function deposit() public payable {
30         balanceOf[msg.sender] += msg.value;
31         emit Deposit(msg.sender, msg.value);
32     }
33     function withdraw(uint wad) public {
34         require(balanceOf[msg.sender] >= wad);
35         balanceOf[msg.sender] -= wad;
36         msg.sender.transfer(wad);
37         emit Withdrawal(msg.sender, wad);
38     }
39 
40     function totalSupply() public view returns (uint) {
41         return address(this).balance;
42     }
43 
44     function approve(address guy, uint wad) public returns (bool) {
45         allowance[msg.sender][guy] = wad;
46         emit Approval(msg.sender, guy, wad);
47         return true;
48     }
49 
50     function transfer(address dst, uint wad) public returns (bool) {
51         return transferFrom(msg.sender, dst, wad);
52     }
53 
54     function transferFrom(address src, address dst, uint wad)
55     public
56     returns (bool)
57     {
58         require(balanceOf[src] >= wad);
59 
60         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
61             require(allowance[src][msg.sender] >= wad);
62             allowance[src][msg.sender] -= wad;
63         }
64 
65         balanceOf[src] -= wad;
66         balanceOf[dst] += wad;
67 
68         Transfer(src, dst, wad);
69 
70         return true;
71     }
72 }
73 
74 /*
75                     GNU GENERAL PUBLIC LICENSE
76                        Version 3, 29 June 2007
77 
78  Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
79  Everyone is permitted to copy and distribute verbatim copies
80  of this license document, but changing it is not allowed.
81 
82                             Preamble
83 
84   The GNU General Public License is a free, copyleft license for
85 software and other kinds of works.
86 
87   The licenses for most software and other practical works are designed
88 to take away your freedom to share and change the works.  By contrast,
89 the GNU General Public License is intended to guarantee your freedom to
90 share and change all versions of a program--to make sure it remains free
91 software for all its users.  We, the Free Software Foundation, use the
92 GNU General Public License for most of our software; it applies also to
93 any other work released this way by its authors.  You can apply it to
94 your programs, too.
95 
96   When we speak of free software, we are referring to freedom, not
97 price.  Our General Public Licenses are designed to make sure that you
98 have the freedom to distribute copies of free software (and charge for
99 them if you wish), that you receive source code or can get it if you
100 want it, that you can change the software or use pieces of it in new
101 free programs, and that you know you can do these things.
102 
103   To protect your rights, we need to prevent others from denying you
104 these rights or asking you to surrender the rights.  Therefore, you have
105 certain responsibilities if you distribute copies of the software, or if
106 you modify it: responsibilities to respect the freedom of others.
107 
108   For example, if you distribute copies of such a program, whether
109 gratis or for a fee, you must pass on to the recipients the same
110 freedoms that you received.  You must make sure that they, too, receive
111 or can get the source code.  And you must show them these terms so they
112 know their rights.
113 
114   Developers that use the GNU GPL protect your rights with two steps:
115 (1) assert copyright on the software, and (2) offer you this License
116 giving you legal permission to copy, distribute and/or modify it.
117 
118   For the developers' and authors' protection, the GPL clearly explains
119 that there is no warranty for this free software.  For both users' and
120 authors' sake, the GPL requires that modified versions be marked as
121 changed, so that their problems will not be attributed erroneously to
122 authors of previous versions.
123 
124   Some devices are designed to deny users access to install or run
125 modified versions of the software inside them, although the manufacturer
126 can do so.  This is fundamentally incompatible with the aim of
127 protecting users' freedom to change the software.  The systematic
128 pattern of such abuse occurs in the area of products for individuals to
129 use, which is precisely where it is most unacceptable.  Therefore, we
130 have designed this version of the GPL to prohibit the practice for those
131 products.  If such problems arise substantially in other domains, we
132 stand ready to extend this provision to those domains in future versions
133 of the GPL, as needed to protect the freedom of users.
134 
135   Finally, every program is threatened constantly by software patents.
136 States should not allow patents to restrict development and use of
137 software on general-purpose computers, but in those that do, we wish to
138 avoid the special danger that patents applied to a free program could
139 make it effectively proprietary.  To prevent this, the GPL assures that
140 patents cannot be used to render the program non-free.
141 
142   The precise terms and conditions for copying, distribution and
143 modification follow.
144 
145                        TERMS AND CONDITIONS
146 
147   0. Definitions.
148 
149   "This License" refers to version 3 of the GNU General Public License.
150 
151   "Copyright" also means copyright-like laws that apply to other kinds of
152 works, such as semiconductor masks.
153 
154   "The Program" refers to any copyrightable work licensed under this
155 License.  Each licensee is addressed as "you".  "Licensees" and
156 "recipients" may be individuals or organizations.
157 
158   To "modify" a work means to copy from or adapt all or part of the work
159 in a fashion requiring copyright permission, other than the making of an
160 exact copy.  The resulting work is called a "modified version" of the
161 earlier work or a work "based on" the earlier work.
162 
163   A "covered work" means either the unmodified Program or a work based
164 on the Program.
165 
166   To "propagate" a work means to do anything with it that, without
167 permission, would make you directly or secondarily liable for
168 infringement under applicable copyright law, except executing it on a
169 computer or modifying a private copy.  Propagation includes copying,
170 distribution (with or without modification), making available to the
171 public, and in some countries other activities as well.
172 
173   To "convey" a work means any kind of propagation that enables other
174 parties to make or receive copies.  Mere interaction with a user through
175 a computer network, with no transfer of a copy, is not conveying.
176 
177   An interactive user interface displays "Appropriate Legal Notices"
178 to the extent that it includes a convenient and prominently visible
179 feature that (1) displays an appropriate copyright notice, and (2)
180 tells the user that there is no warranty for the work (except to the
181 extent that warranties are provided), that licensees may convey the
182 work under this License, and how to view a copy of this License.  If
183 the interface presents a list of user commands or options, such as a
184 menu, a prominent item in the list meets this criterion.
185 
186   1. Source Code.
187 
188   The "source code" for a work means the preferred form of the work
189 for making modifications to it.  "Object code" means any non-source
190 form of a work.
191 
192   A "Standard Interface" means an interface that either is an official
193 standard defined by a recognized standards body, or, in the case of
194 interfaces specified for a particular programming language, one that
195 is widely used among developers working in that language.
196 
197   The "System Libraries" of an executable work include anything, other
198 than the work as a whole, that (a) is included in the normal form of
199 packaging a Major Component, but which is not part of that Major
200 Component, and (b) serves only to enable use of the work with that
201 Major Component, or to implement a Standard Interface for which an
202 implementation is available to the public in source code form.  A
203 "Major Component", in this context, means a major essential component
204 (kernel, window system, and so on) of the specific operating system
205 (if any) on which the executable work runs, or a compiler used to
206 produce the work, or an object code interpreter used to run it.
207 
208   The "Corresponding Source" for a work in object code form means all
209 the source code needed to generate, install, and (for an executable
210 work) run the object code and to modify the work, including scripts to
211 control those activities.  However, it does not include the work's
212 System Libraries, or general-purpose tools or generally available free
213 programs which are used unmodified in performing those activities but
214 which are not part of the work.  For example, Corresponding Source
215 includes interface definition files associated with source files for
216 the work, and the source code for shared libraries and dynamically
217 linked subprograms that the work is specifically designed to require,
218 such as by intimate data communication or control flow between those
219 subprograms and other parts of the work.
220 
221   The Corresponding Source need not include anything that users
222 can regenerate automatically from other parts of the Corresponding
223 Source.
224 
225   The Corresponding Source for a work in source code form is that
226 same work.
227 
228   2. Basic Permissions.
229 
230   All rights granted under this License are granted for the term of
231 copyright on the Program, and are irrevocable provided the stated
232 conditions are met.  This License explicitly affirms your unlimited
233 permission to run the unmodified Program.  The output from running a
234 covered work is covered by this License only if the output, given its
235 content, constitutes a covered work.  This License acknowledges your
236 rights of fair use or other equivalent, as provided by copyright law.
237 
238   You may make, run and propagate covered works that you do not
239 convey, without conditions so long as your license otherwise remains
240 in force.  You may convey covered works to others for the sole purpose
241 of having them make modifications exclusively for you, or provide you
242 with facilities for running those works, provided that you comply with
243 the terms of this License in conveying all material for which you do
244 not control copyright.  Those thus making or running the covered works
245 for you must do so exclusively on your behalf, under your direction
246 and control, on terms that prohibit them from making any copies of
247 your copyrighted material outside their relationship with you.
248 
249   Conveying under any other circumstances is permitted solely under
250 the conditions stated below.  Sublicensing is not allowed; section 10
251 makes it unnecessary.
252 
253   3. Protecting Users' Legal Rights From Anti-Circumvention Law.
254 
255   No covered work shall be deemed part of an effective technological
256 measure under any applicable law fulfilling obligations under article
257 11 of the WIPO copyright treaty adopted on 20 December 1996, or
258 similar laws prohibiting or restricting circumvention of such
259 measures.
260 
261   When you convey a covered work, you waive any legal power to forbid
262 circumvention of technological measures to the extent such circumvention
263 is effected by exercising rights under this License with respect to
264 the covered work, and you disclaim any intention to limit operation or
265 modification of the work as a means of enforcing, against the work's
266 users, your or third parties' legal rights to forbid circumvention of
267 technological measures.
268 
269   4. Conveying Verbatim Copies.
270 
271   You may convey verbatim copies of the Program's source code as you
272 receive it, in any medium, provided that you conspicuously and
273 appropriately publish on each copy an appropriate copyright notice;
274 keep intact all notices stating that this License and any
275 non-permissive terms added in accord with section 7 apply to the code;
276 keep intact all notices of the absence of any warranty; and give all
277 recipients a copy of this License along with the Program.
278 
279   You may charge any price or no price for each copy that you convey,
280 and you may offer support or warranty protection for a fee.
281 
282   5. Conveying Modified Source Versions.
283 
284   You may convey a work based on the Program, or the modifications to
285 produce it from the Program, in the form of source code under the
286 terms of section 4, provided that you also meet all of these conditions:
287 
288     a) The work must carry prominent notices stating that you modified
289     it, and giving a relevant date.
290 
291     b) The work must carry prominent notices stating that it is
292     released under this License and any conditions added under section
293     7.  This requirement modifies the requirement in section 4 to
294     "keep intact all notices".
295 
296     c) You must license the entire work, as a whole, under this
297     License to anyone who comes into possession of a copy.  This
298     License will therefore apply, along with any applicable section 7
299     additional terms, to the whole of the work, and all its parts,
300     regardless of how they are packaged.  This License gives no
301     permission to license the work in any other way, but it does not
302     invalidate such permission if you have separately received it.
303 
304     d) If the work has interactive user interfaces, each must display
305     Appropriate Legal Notices; however, if the Program has interactive
306     interfaces that do not display Appropriate Legal Notices, your
307     work need not make them do so.
308 
309   A compilation of a covered work with other separate and independent
310 works, which are not by their nature extensions of the covered work,
311 and which are not combined with it such as to form a larger program,
312 in or on a volume of a storage or distribution medium, is called an
313 "aggregate" if the compilation and its resulting copyright are not
314 used to limit the access or legal rights of the compilation's users
315 beyond what the individual works permit.  Inclusion of a covered work
316 in an aggregate does not cause this License to apply to the other
317 parts of the aggregate.
318 
319   6. Conveying Non-Source Forms.
320 
321   You may convey a covered work in object code form under the terms
322 of sections 4 and 5, provided that you also convey the
323 machine-readable Corresponding Source under the terms of this License,
324 in one of these ways:
325 
326     a) Convey the object code in, or embodied in, a physical product
327     (including a physical distribution medium), accompanied by the
328     Corresponding Source fixed on a durable physical medium
329     customarily used for software interchange.
330 
331     b) Convey the object code in, or embodied in, a physical product
332     (including a physical distribution medium), accompanied by a
333     written offer, valid for at least three years and valid for as
334     long as you offer spare parts or customer support for that product
335     model, to give anyone who possesses the object code either (1) a
336     copy of the Corresponding Source for all the software in the
337     product that is covered by this License, on a durable physical
338     medium customarily used for software interchange, for a price no
339     more than your reasonable cost of physically performing this
340     conveying of source, or (2) access to copy the
341     Corresponding Source from a network server at no charge.
342 
343     c) Convey individual copies of the object code with a copy of the
344     written offer to provide the Corresponding Source.  This
345     alternative is allowed only occasionally and noncommercially, and
346     only if you received the object code with such an offer, in accord
347     with subsection 6b.
348 
349     d) Convey the object code by offering access from a designated
350     place (gratis or for a charge), and offer equivalent access to the
351     Corresponding Source in the same way through the same place at no
352     further charge.  You need not require recipients to copy the
353     Corresponding Source along with the object code.  If the place to
354     copy the object code is a network server, the Corresponding Source
355     may be on a different server (operated by you or a third party)
356     that supports equivalent copying facilities, provided you maintain
357     clear directions next to the object code saying where to find the
358     Corresponding Source.  Regardless of what server hosts the
359     Corresponding Source, you remain obligated to ensure that it is
360     available for as long as needed to satisfy these requirements.
361 
362     e) Convey the object code using peer-to-peer transmission, provided
363     you inform other peers where the object code and Corresponding
364     Source of the work are being offered to the general public at no
365     charge under subsection 6d.
366 
367   A separable portion of the object code, whose source code is excluded
368 from the Corresponding Source as a System Library, need not be
369 included in conveying the object code work.
370 
371   A "User Product" is either (1) a "consumer product", which means any
372 tangible personal property which is normally used for personal, family,
373 or household purposes, or (2) anything designed or sold for incorporation
374 into a dwelling.  In determining whether a product is a consumer product,
375 doubtful cases shall be resolved in favor of coverage.  For a particular
376 product received by a particular user, "normally used" refers to a
377 typical or common use of that class of product, regardless of the status
378 of the particular user or of the way in which the particular user
379 actually uses, or expects or is expected to use, the product.  A product
380 is a consumer product regardless of whether the product has substantial
381 commercial, industrial or non-consumer uses, unless such uses represent
382 the only significant mode of use of the product.
383 
384   "Installation Information" for a User Product means any methods,
385 procedures, authorization keys, or other information required to install
386 and execute modified versions of a covered work in that User Product from
387 a modified version of its Corresponding Source.  The information must
388 suffice to ensure that the continued functioning of the modified object
389 code is in no case prevented or interfered with solely because
390 modification has been made.
391 
392   If you convey an object code work under this section in, or with, or
393 specifically for use in, a User Product, and the conveying occurs as
394 part of a transaction in which the right of possession and use of the
395 User Product is transferred to the recipient in perpetuity or for a
396 fixed term (regardless of how the transaction is characterized), the
397 Corresponding Source conveyed under this section must be accompanied
398 by the Installation Information.  But this requirement does not apply
399 if neither you nor any third party retains the ability to install
400 modified object code on the User Product (for example, the work has
401 been installed in ROM).
402 
403   The requirement to provide Installation Information does not include a
404 requirement to continue to provide support service, warranty, or updates
405 for a work that has been modified or installed by the recipient, or for
406 the User Product in which it has been modified or installed.  Access to a
407 network may be denied when the modification itself materially and
408 adversely affects the operation of the network or violates the rules and
409 protocols for communication across the network.
410 
411   Corresponding Source conveyed, and Installation Information provided,
412 in accord with this section must be in a format that is publicly
413 documented (and with an implementation available to the public in
414 source code form), and must require no special password or key for
415 unpacking, reading or copying.
416 
417   7. Additional Terms.
418 
419   "Additional permissions" are terms that supplement the terms of this
420 License by making exceptions from one or more of its conditions.
421 Additional permissions that are applicable to the entire Program shall
422 be treated as though they were included in this License, to the extent
423 that they are valid under applicable law.  If additional permissions
424 apply only to part of the Program, that part may be used separately
425 under those permissions, but the entire Program remains governed by
426 this License without regard to the additional permissions.
427 
428   When you convey a copy of a covered work, you may at your option
429 remove any additional permissions from that copy, or from any part of
430 it.  (Additional permissions may be written to require their own
431 removal in certain cases when you modify the work.)  You may place
432 additional permissions on material, added by you to a covered work,
433 for which you have or can give appropriate copyright permission.
434 
435   Notwithstanding any other provision of this License, for material you
436 add to a covered work, you may (if authorized by the copyright holders of
437 that material) supplement the terms of this License with terms:
438 
439     a) Disclaiming warranty or limiting liability differently from the
440     terms of sections 15 and 16 of this License; or
441 
442     b) Requiring preservation of specified reasonable legal notices or
443     author attributions in that material or in the Appropriate Legal
444     Notices displayed by works containing it; or
445 
446     c) Prohibiting misrepresentation of the origin of that material, or
447     requiring that modified versions of such material be marked in
448     reasonable ways as different from the original version; or
449 
450     d) Limiting the use for publicity purposes of names of licensors or
451     authors of the material; or
452 
453     e) Declining to grant rights under trademark law for use of some
454     trade names, trademarks, or service marks; or
455 
456     f) Requiring indemnification of licensors and authors of that
457     material by anyone who conveys the material (or modified versions of
458     it) with contractual assumptions of liability to the recipient, for
459     any liability that these contractual assumptions directly impose on
460     those licensors and authors.
461 
462   All other non-permissive additional terms are considered "further
463 restrictions" within the meaning of section 10.  If the Program as you
464 received it, or any part of it, contains a notice stating that it is
465 governed by this License along with a term that is a further
466 restriction, you may remove that term.  If a license document contains
467 a further restriction but permits relicensing or conveying under this
468 License, you may add to a covered work material governed by the terms
469 of that license document, provided that the further restriction does
470 not survive such relicensing or conveying.
471 
472   If you add terms to a covered work in accord with this section, you
473 must place, in the relevant source files, a statement of the
474 additional terms that apply to those files, or a notice indicating
475 where to find the applicable terms.
476 
477   Additional terms, permissive or non-permissive, may be stated in the
478 form of a separately written license, or stated as exceptions;
479 the above requirements apply either way.
480 
481   8. Termination.
482 
483   You may not propagate or modify a covered work except as expressly
484 provided under this License.  Any attempt otherwise to propagate or
485 modify it is void, and will automatically terminate your rights under
486 this License (including any patent licenses granted under the third
487 paragraph of section 11).
488 
489   However, if you cease all violation of this License, then your
490 license from a particular copyright holder is reinstated (a)
491 provisionally, unless and until the copyright holder explicitly and
492 finally terminates your license, and (b) permanently, if the copyright
493 holder fails to notify you of the violation by some reasonable means
494 prior to 60 days after the cessation.
495 
496   Moreover, your license from a particular copyright holder is
497 reinstated permanently if the copyright holder notifies you of the
498 violation by some reasonable means, this is the first time you have
499 received notice of violation of this License (for any work) from that
500 copyright holder, and you cure the violation prior to 30 days after
501 your receipt of the notice.
502 
503   Termination of your rights under this section does not terminate the
504 licenses of parties who have received copies or rights from you under
505 this License.  If your rights have been terminated and not permanently
506 reinstated, you do not qualify to receive new licenses for the same
507 material under section 10.
508 
509   9. Acceptance Not Required for Having Copies.
510 
511   You are not required to accept this License in order to receive or
512 run a copy of the Program.  Ancillary propagation of a covered work
513 occurring solely as a consequence of using peer-to-peer transmission
514 to receive a copy likewise does not require acceptance.  However,
515 nothing other than this License grants you permission to propagate or
516 modify any covered work.  These actions infringe copyright if you do
517 not accept this License.  Therefore, by modifying or propagating a
518 covered work, you indicate your acceptance of this License to do so.
519 
520   10. Automatic Licensing of Downstream Recipients.
521 
522   Each time you convey a covered work, the recipient automatically
523 receives a license from the original licensors, to run, modify and
524 propagate that work, subject to this License.  You are not responsible
525 for enforcing compliance by third parties with this License.
526 
527   An "entity transaction" is a transaction transferring control of an
528 organization, or substantially all assets of one, or subdividing an
529 organization, or merging organizations.  If propagation of a covered
530 work results from an entity transaction, each party to that
531 transaction who receives a copy of the work also receives whatever
532 licenses to the work the party's predecessor in interest had or could
533 give under the previous paragraph, plus a right to possession of the
534 Corresponding Source of the work from the predecessor in interest, if
535 the predecessor has it or can get it with reasonable efforts.
536 
537   You may not impose any further restrictions on the exercise of the
538 rights granted or affirmed under this License.  For example, you may
539 not impose a license fee, royalty, or other charge for exercise of
540 rights granted under this License, and you may not initiate litigation
541 (including a cross-claim or counterclaim in a lawsuit) alleging that
542 any patent claim is infringed by making, using, selling, offering for
543 sale, or importing the Program or any portion of it.
544 
545   11. Patents.
546 
547   A "contributor" is a copyright holder who authorizes use under this
548 License of the Program or a work on which the Program is based.  The
549 work thus licensed is called the contributor's "contributor version".
550 
551   A contributor's "essential patent claims" are all patent claims
552 owned or controlled by the contributor, whether already acquired or
553 hereafter acquired, that would be infringed by some manner, permitted
554 by this License, of making, using, or selling its contributor version,
555 but do not include claims that would be infringed only as a
556 consequence of further modification of the contributor version.  For
557 purposes of this definition, "control" includes the right to grant
558 patent sublicenses in a manner consistent with the requirements of
559 this License.
560 
561   Each contributor grants you a non-exclusive, worldwide, royalty-free
562 patent license under the contributor's essential patent claims, to
563 make, use, sell, offer for sale, import and otherwise run, modify and
564 propagate the contents of its contributor version.
565 
566   In the following three paragraphs, a "patent license" is any express
567 agreement or commitment, however denominated, not to enforce a patent
568 (such as an express permission to practice a patent or covenant not to
569 sue for patent infringement).  To "grant" such a patent license to a
570 party means to make such an agreement or commitment not to enforce a
571 patent against the party.
572 
573   If you convey a covered work, knowingly relying on a patent license,
574 and the Corresponding Source of the work is not available for anyone
575 to copy, free of charge and under the terms of this License, through a
576 publicly available network server or other readily accessible means,
577 then you must either (1) cause the Corresponding Source to be so
578 available, or (2) arrange to deprive yourself of the benefit of the
579 patent license for this particular work, or (3) arrange, in a manner
580 consistent with the requirements of this License, to extend the patent
581 license to downstream recipients.  "Knowingly relying" means you have
582 actual knowledge that, but for the patent license, your conveying the
583 covered work in a country, or your recipient's use of the covered work
584 in a country, would infringe one or more identifiable patents in that
585 country that you have reason to believe are valid.
586 
587   If, pursuant to or in connection with a single transaction or
588 arrangement, you convey, or propagate by procuring conveyance of, a
589 covered work, and grant a patent license to some of the parties
590 receiving the covered work authorizing them to use, propagate, modify
591 or convey a specific copy of the covered work, then the patent license
592 you grant is automatically extended to all recipients of the covered
593 work and works based on it.
594 
595   A patent license is "discriminatory" if it does not include within
596 the scope of its coverage, prohibits the exercise of, or is
597 conditioned on the non-exercise of one or more of the rights that are
598 specifically granted under this License.  You may not convey a covered
599 work if you are a party to an arrangement with a third party that is
600 in the business of distributing software, under which you make payment
601 to the third party based on the extent of your activity of conveying
602 the work, and under which the third party grants, to any of the
603 parties who would receive the covered work from you, a discriminatory
604 patent license (a) in connection with copies of the covered work
605 conveyed by you (or copies made from those copies), or (b) primarily
606 for and in connection with specific products or compilations that
607 contain the covered work, unless you entered into that arrangement,
608 or that patent license was granted, prior to 28 March 2007.
609 
610   Nothing in this License shall be construed as excluding or limiting
611 any implied license or other defenses to infringement that may
612 otherwise be available to you under applicable patent law.
613 
614   12. No Surrender of Others' Freedom.
615 
616   If conditions are imposed on you (whether by court order, agreement or
617 otherwise) that contradict the conditions of this License, they do not
618 excuse you from the conditions of this License.  If you cannot convey a
619 covered work so as to satisfy simultaneously your obligations under this
620 License and any other pertinent obligations, then as a consequence you may
621 not convey it at all.  For example, if you agree to terms that obligate you
622 to collect a royalty for further conveying from those to whom you convey
623 the Program, the only way you could satisfy both those terms and this
624 License would be to refrain entirely from conveying the Program.
625 
626   13. Use with the GNU Affero General Public License.
627 
628   Notwithstanding any other provision of this License, you have
629 permission to link or combine any covered work with a work licensed
630 under version 3 of the GNU Affero General Public License into a single
631 combined work, and to convey the resulting work.  The terms of this
632 License will continue to apply to the part which is the covered work,
633 but the special requirements of the GNU Affero General Public License,
634 section 13, concerning interaction through a network will apply to the
635 combination as such.
636 
637   14. Revised Versions of this License.
638 
639   The Free Software Foundation may publish revised and/or new versions of
640 the GNU General Public License from time to time.  Such new versions will
641 be similar in spirit to the present version, but may differ in detail to
642 address new problems or concerns.
643 
644   Each version is given a distinguishing version number.  If the
645 Program specifies that a certain numbered version of the GNU General
646 Public License "or any later version" applies to it, you have the
647 option of following the terms and conditions either of that numbered
648 version or of any later version published by the Free Software
649 Foundation.  If the Program does not specify a version number of the
650 GNU General Public License, you may choose any version ever published
651 by the Free Software Foundation.
652 
653   If the Program specifies that a proxy can decide which future
654 versions of the GNU General Public License can be used, that proxy's
655 public statement of acceptance of a version permanently authorizes you
656 to choose that version for the Program.
657 
658   Later license versions may give you additional or different
659 permissions.  However, no additional obligations are imposed on any
660 author or copyright holder as a result of your choosing to follow a
661 later version.
662 
663   15. Disclaimer of Warranty.
664 
665   THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
666 APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
667 HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
668 OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
669 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
670 PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
671 IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
672 ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
673 
674   16. Limitation of Liability.
675 
676   IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
677 WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
678 THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
679 GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
680 USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
681 DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
682 PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
683 EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
684 SUCH DAMAGES.
685 
686   17. Interpretation of Sections 15 and 16.
687 
688   If the disclaimer of warranty and limitation of liability provided
689 above cannot be given local legal effect according to their terms,
690 reviewing courts shall apply local law that most closely approximates
691 an absolute waiver of all civil liability in connection with the
692 Program, unless a warranty or assumption of liability accompanies a
693 copy of the Program in return for a fee.
694 
695                      END OF TERMS AND CONDITIONS
696 
697             How to Apply These Terms to Your New Programs
698 
699   If you develop a new program, and you want it to be of the greatest
700 possible use to the public, the best way to achieve this is to make it
701 free software which everyone can redistribute and change under these terms.
702 
703   To do so, attach the following notices to the program.  It is safest
704 to attach them to the start of each source file to most effectively
705 state the exclusion of warranty; and each file should have at least
706 the "copyright" line and a pointer to where the full notice is found.
707 
708     <one line to give the program's name and a brief idea of what it does.>
709     Copyright (C) <year>  <name of author>
710 
711     This program is free software: you can redistribute it and/or modify
712     it under the terms of the GNU General Public License as published by
713     the Free Software Foundation, either version 3 of the License, or
714     (at your option) any later version.
715 
716     This program is distributed in the hope that it will be useful,
717     but WITHOUT ANY WARRANTY; without even the implied warranty of
718     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
719     GNU General Public License for more details.
720 
721     You should have received a copy of the GNU General Public License
722     along with this program.  If not, see <http://www.gnu.org/licenses/>.
723 
724 Also add information on how to contact you by electronic and paper mail.
725 
726   If the program does terminal interaction, make it output a short
727 notice like this when it starts in an interactive mode:
728 
729     <program>  Copyright (C) <year>  <name of author>
730     This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
731     This is free software, and you are welcome to redistribute it
732     under certain conditions; type `show c' for details.
733 
734 The hypothetical commands `show w' and `show c' should show the appropriate
735 parts of the General Public License.  Of course, your program's commands
736 might be different; for a GUI interface, you would use an "about box".
737 
738   You should also get your employer (if you work as a programmer) or school,
739 if any, to sign a "copyright disclaimer" for the program, if necessary.
740 For more information on this, and how to apply and follow the GNU GPL, see
741 <http://www.gnu.org/licenses/>.
742 
743   The GNU General Public License does not permit incorporating your program
744 into proprietary programs.  If your program is a subroutine library, you
745 may consider it more useful to permit linking proprietary applications with
746 the library.  If this is what you want to do, use the GNU Lesser General
747 Public License instead of this License.  But first, please read
748 <http://www.gnu.org/philosophy/why-not-lgpl.html>.
749 
750 */
