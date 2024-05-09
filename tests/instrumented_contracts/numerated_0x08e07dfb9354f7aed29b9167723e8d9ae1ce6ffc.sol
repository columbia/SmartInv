1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title ERC20Detailed token
27  * @dev The decimals are only for visualization purposes.
28  * All the operations are done using the smallest and indivisible token unit,
29  * just as on Ethereum all the operations are done in wei.
30  */
31 contract ERC20Detailed is IERC20 {
32     string private _name;
33     string private _symbol;
34     uint8 private _decimals;
35 
36     constructor (string memory name, string memory symbol, uint8 decimals) public {
37         _name = name;
38         _symbol = symbol;
39         _decimals = decimals;
40     }
41 
42     /**
43      * @return the name of the token.
44      */
45     function name() public view returns (string memory) {
46         return _name;
47     }
48 
49     /**
50      * @return the symbol of the token.
51      */
52     function symbol() public view returns (string memory) {
53         return _symbol;
54     }
55 
56     /**
57      * @return the number of decimals of the token.
58      */
59     function decimals() public view returns (uint8) {
60         return _decimals;
61     }
62 }
63 
64 /**
65  * Utility library of inline functions on addresses
66  */
67 library Address {
68     /**
69      * Returns whether the target address is a contract
70      * @dev This function will return false if invoked during the constructor of a contract,
71      * as the code is not actually created until after the constructor finishes.
72      * @param account address of the account to check
73      * @return whether the target address is a contract
74      */
75     function isContract(address account) internal view returns (bool) {
76         uint256 size;
77         // XXX Currently there is no better way to check if there is a contract in an address
78         // than to check the size of the code at that address.
79         // See https://ethereum.stackexchange.com/a/14016/36603
80         // for more details about how this works.
81         // TODO Check this again before the Serenity release, because all addresses will be
82         // contracts then.
83         // solhint-disable-next-line no-inline-assembly
84         assembly { size := extcodesize(account) }
85         return size > 0;
86     }
87 }
88 
89 /**
90  * @title ERC165Checker
91  * @dev Use `using ERC165Checker for address`; to include this library
92  * https://eips.ethereum.org/EIPS/eip-165
93  */
94 library ERC165Checker {
95     // As per the EIP-165 spec, no interface should ever match 0xffffffff
96     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
97 
98     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
99     /*
100      * 0x01ffc9a7 ===
101      *     bytes4(keccak256('supportsInterface(bytes4)'))
102      */
103 
104     /**
105      * @notice Query if a contract supports ERC165
106      * @param account The address of the contract to query for support of ERC165
107      * @return true if the contract at account implements ERC165
108      */
109     function _supportsERC165(address account) internal view returns (bool) {
110         // Any contract that implements ERC165 must explicitly indicate support of
111         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
112         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
113             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
114     }
115 
116     /**
117      * @notice Query if a contract implements an interface, also checks support of ERC165
118      * @param account The address of the contract to query for support of an interface
119      * @param interfaceId The interface identifier, as specified in ERC-165
120      * @return true if the contract at account indicates support of the interface with
121      * identifier interfaceId, false otherwise
122      * @dev Interface identification is specified in ERC-165.
123      */
124     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
125         // query support of both ERC165 as per the spec and support of _interfaceId
126         return _supportsERC165(account) &&
127             _supportsERC165Interface(account, interfaceId);
128     }
129 
130     /**
131      * @notice Query if a contract implements interfaces, also checks support of ERC165
132      * @param account The address of the contract to query for support of an interface
133      * @param interfaceIds A list of interface identifiers, as specified in ERC-165
134      * @return true if the contract at account indicates support all interfaces in the
135      * interfaceIds list, false otherwise
136      * @dev Interface identification is specified in ERC-165.
137      */
138     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
139         // query support of ERC165 itself
140         if (!_supportsERC165(account)) {
141             return false;
142         }
143 
144         // query support of each interface in _interfaceIds
145         for (uint256 i = 0; i < interfaceIds.length; i++) {
146             if (!_supportsERC165Interface(account, interfaceIds[i])) {
147                 return false;
148             }
149         }
150 
151         // all interfaces supported
152         return true;
153     }
154 
155     /**
156      * @notice Query if a contract implements an interface, does not check ERC165 support
157      * @param account The address of the contract to query for support of an interface
158      * @param interfaceId The interface identifier, as specified in ERC-165
159      * @return true if the contract at account indicates support of the interface with
160      * identifier interfaceId, false otherwise
161      * @dev Assumes that account contains a contract that supports ERC165, otherwise
162      * the behavior of this method is undefined. This precondition can be checked
163      * with the `supportsERC165` method in this library.
164      * Interface identification is specified in ERC-165.
165      */
166     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
167         // success determines whether the staticcall succeeded and result determines
168         // whether the contract at account indicates support of _interfaceId
169         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
170 
171         return (success && result);
172     }
173 
174     /**
175      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
176      * @param account The address of the contract to query for support of an interface
177      * @param interfaceId The interface identifier, as specified in ERC-165
178      * @return success true if the STATICCALL succeeded, false otherwise
179      * @return result true if the STATICCALL succeeded and the contract at account
180      * indicates support of the interface with identifier interfaceId, false otherwise
181      */
182     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
183         private
184         view
185         returns (bool success, bool result)
186     {
187         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
188 
189         // solhint-disable-next-line no-inline-assembly
190         assembly {
191             let encodedParams_data := add(0x20, encodedParams)
192             let encodedParams_size := mload(encodedParams)
193 
194             let output := mload(0x40)    // Find empty storage location using "free memory pointer"
195             mstore(output, 0x0)
196 
197             success := staticcall(
198                 30000,                   // 30k gas
199                 account,                 // To addr
200                 encodedParams_data,
201                 encodedParams_size,
202                 output,
203                 0x20                     // Outputs are 32 bytes long
204             )
205 
206             result := mload(output)      // Load the result
207         }
208     }
209 }
210 
211 /**
212  * @title SafeMath
213  * @dev Unsigned math operations with safety checks that revert on error
214  */
215 library SafeMath {
216     /**
217      * @dev Multiplies two unsigned integers, reverts on overflow.
218      */
219     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
220         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
221         // benefit is lost if 'b' is also tested.
222         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
223         if (a == 0) {
224             return 0;
225         }
226 
227         uint256 c = a * b;
228         require(c / a == b);
229 
230         return c;
231     }
232 
233     /**
234      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
235      */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Solidity only automatically asserts when dividing by 0
238         require(b > 0);
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
247      */
248     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
249         require(b <= a);
250         uint256 c = a - b;
251 
252         return c;
253     }
254 
255     /**
256      * @dev Adds two unsigned integers, reverts on overflow.
257      */
258     function add(uint256 a, uint256 b) internal pure returns (uint256) {
259         uint256 c = a + b;
260         require(c >= a);
261 
262         return c;
263     }
264 
265     /**
266      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
267      * reverts when dividing by zero.
268      */
269     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
270         require(b != 0);
271         return a % b;
272     }
273 }
274 
275 /**
276  * @title Standard ERC20 token
277  *
278  * @dev Implementation of the basic standard token.
279  * https://eips.ethereum.org/EIPS/eip-20
280  * Originally based on code by FirstBlood:
281  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
282  *
283  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
284  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
285  * compliant implementations may not do it.
286  */
287 contract ERC20 is IERC20 {
288     using SafeMath for uint256;
289 
290     mapping (address => uint256) private _balances;
291 
292     mapping (address => mapping (address => uint256)) private _allowed;
293 
294     uint256 private _totalSupply;
295 
296     /**
297      * @dev Total number of tokens in existence
298      */
299     function totalSupply() public view returns (uint256) {
300         return _totalSupply;
301     }
302 
303     /**
304      * @dev Gets the balance of the specified address.
305      * @param owner The address to query the balance of.
306      * @return A uint256 representing the amount owned by the passed address.
307      */
308     function balanceOf(address owner) public view returns (uint256) {
309         return _balances[owner];
310     }
311 
312     /**
313      * @dev Function to check the amount of tokens that an owner allowed to a spender.
314      * @param owner address The address which owns the funds.
315      * @param spender address The address which will spend the funds.
316      * @return A uint256 specifying the amount of tokens still available for the spender.
317      */
318     function allowance(address owner, address spender) public view returns (uint256) {
319         return _allowed[owner][spender];
320     }
321 
322     /**
323      * @dev Transfer token to a specified address
324      * @param to The address to transfer to.
325      * @param value The amount to be transferred.
326      */
327     function transfer(address to, uint256 value) public returns (bool) {
328         _transfer(msg.sender, to, value);
329         return true;
330     }
331 
332     /**
333      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
334      * Beware that changing an allowance with this method brings the risk that someone may use both the old
335      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
336      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
337      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
338      * @param spender The address which will spend the funds.
339      * @param value The amount of tokens to be spent.
340      */
341     function approve(address spender, uint256 value) public returns (bool) {
342         _approve(msg.sender, spender, value);
343         return true;
344     }
345 
346     /**
347      * @dev Transfer tokens from one address to another.
348      * Note that while this function emits an Approval event, this is not required as per the specification,
349      * and other compliant implementations may not emit the event.
350      * @param from address The address which you want to send tokens from
351      * @param to address The address which you want to transfer to
352      * @param value uint256 the amount of tokens to be transferred
353      */
354     function transferFrom(address from, address to, uint256 value) public returns (bool) {
355         _transfer(from, to, value);
356         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
357         return true;
358     }
359 
360     /**
361      * @dev Increase the amount of tokens that an owner allowed to a spender.
362      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
363      * allowed value is better to use this function to avoid 2 calls (and wait until
364      * the first transaction is mined)
365      * From MonolithDAO Token.sol
366      * Emits an Approval event.
367      * @param spender The address which will spend the funds.
368      * @param addedValue The amount of tokens to increase the allowance by.
369      */
370     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
371         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
372         return true;
373     }
374 
375     /**
376      * @dev Decrease the amount of tokens that an owner allowed to a spender.
377      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
378      * allowed value is better to use this function to avoid 2 calls (and wait until
379      * the first transaction is mined)
380      * From MonolithDAO Token.sol
381      * Emits an Approval event.
382      * @param spender The address which will spend the funds.
383      * @param subtractedValue The amount of tokens to decrease the allowance by.
384      */
385     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
386         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Transfer token for a specified addresses
392      * @param from The address to transfer from.
393      * @param to The address to transfer to.
394      * @param value The amount to be transferred.
395      */
396     function _transfer(address from, address to, uint256 value) internal {
397         require(to != address(0));
398 
399         _balances[from] = _balances[from].sub(value);
400         _balances[to] = _balances[to].add(value);
401         emit Transfer(from, to, value);
402     }
403 
404     /**
405      * @dev Internal function that mints an amount of the token and assigns it to
406      * an account. This encapsulates the modification of balances such that the
407      * proper events are emitted.
408      * @param account The account that will receive the created tokens.
409      * @param value The amount that will be created.
410      */
411     function _mint(address account, uint256 value) internal {
412         require(account != address(0));
413 
414         _totalSupply = _totalSupply.add(value);
415         _balances[account] = _balances[account].add(value);
416         emit Transfer(address(0), account, value);
417     }
418 
419     /**
420      * @dev Internal function that burns an amount of the token of a given
421      * account.
422      * @param account The account whose tokens will be burnt.
423      * @param value The amount that will be burnt.
424      */
425     function _burn(address account, uint256 value) internal {
426         require(account != address(0));
427 
428         _totalSupply = _totalSupply.sub(value);
429         _balances[account] = _balances[account].sub(value);
430         emit Transfer(account, address(0), value);
431     }
432 
433     /**
434      * @dev Approve an address to spend another addresses' tokens.
435      * @param owner The address that owns the tokens.
436      * @param spender The address that will spend the tokens.
437      * @param value The number of tokens that can be spent.
438      */
439     function _approve(address owner, address spender, uint256 value) internal {
440         require(spender != address(0));
441         require(owner != address(0));
442 
443         _allowed[owner][spender] = value;
444         emit Approval(owner, spender, value);
445     }
446 
447     /**
448      * @dev Internal function that burns an amount of the token of a given
449      * account, deducting from the sender's allowance for said account. Uses the
450      * internal burn function.
451      * Emits an Approval event (reflecting the reduced allowance).
452      * @param account The account whose tokens will be burnt.
453      * @param value The amount that will be burnt.
454      */
455     function _burnFrom(address account, uint256 value) internal {
456         _burn(account, value);
457         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
458     }
459 }
460 
461 /**
462  * @title IERC165
463  * @dev https://eips.ethereum.org/EIPS/eip-165
464  */
465 interface IERC165 {
466     /**
467      * @notice Query if a contract implements an interface
468      * @param interfaceId The interface identifier, as specified in ERC-165
469      * @dev Interface identification is specified in ERC-165. This function
470      * uses less than 30,000 gas.
471      */
472     function supportsInterface(bytes4 interfaceId) external view returns (bool);
473 }
474 
475 /**
476  * @title ERC165
477  * @author Matt Condon (@shrugs)
478  * @dev Implements ERC165 using a lookup table.
479  */
480 contract ERC165 is IERC165 {
481     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
482     /*
483      * 0x01ffc9a7 ===
484      *     bytes4(keccak256('supportsInterface(bytes4)'))
485      */
486 
487     /**
488      * @dev a mapping of interface id to whether or not it's supported
489      */
490     mapping(bytes4 => bool) private _supportedInterfaces;
491 
492     /**
493      * @dev A contract implementing SupportsInterfaceWithLookup
494      * implement ERC165 itself
495      */
496     constructor () internal {
497         _registerInterface(_INTERFACE_ID_ERC165);
498     }
499 
500     /**
501      * @dev implement supportsInterface(bytes4) using a lookup table
502      */
503     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
504         return _supportedInterfaces[interfaceId];
505     }
506 
507     /**
508      * @dev internal method for registering an interface
509      */
510     function _registerInterface(bytes4 interfaceId) internal {
511         require(interfaceId != 0xffffffff);
512         _supportedInterfaces[interfaceId] = true;
513     }
514 }
515 
516 /**
517  * @title IERC1363 Interface
518  * @author Vittorio Minacori (https://github.com/vittominacori)
519  * @dev Interface for a Payable Token contract as defined in
520  *  https://github.com/ethereum/EIPs/issues/1363
521  */
522 contract IERC1363 is IERC20, ERC165 {
523     /*
524      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
525      * 0x4bbee2df ===
526      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
527      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
528      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
529      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
530      */
531 
532     /*
533      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
534      * 0xfb9ec8ce ===
535      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
536      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
537      */
538 
539     /**
540      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
541      * @param to address The address which you want to transfer to
542      * @param value uint256 The amount of tokens to be transferred
543      * @return true unless throwing
544      */
545     function transferAndCall(address to, uint256 value) public returns (bool);
546 
547     /**
548      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
549      * @param to address The address which you want to transfer to
550      * @param value uint256 The amount of tokens to be transferred
551      * @param data bytes Additional data with no specified format, sent in call to `to`
552      * @return true unless throwing
553      */
554     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool);
555 
556     /**
557      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
558      * @param from address The address which you want to send tokens from
559      * @param to address The address which you want to transfer to
560      * @param value uint256 The amount of tokens to be transferred
561      * @return true unless throwing
562      */
563     function transferFromAndCall(address from, address to, uint256 value) public returns (bool);
564 
565 
566     /**
567      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
568      * @param from address The address which you want to send tokens from
569      * @param to address The address which you want to transfer to
570      * @param value uint256 The amount of tokens to be transferred
571      * @param data bytes Additional data with no specified format, sent in call to `to`
572      * @return true unless throwing
573      */
574     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool);
575 
576     /**
577      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
578      * and then call `onApprovalReceived` on spender.
579      * Beware that changing an allowance with this method brings the risk that someone may use both the old
580      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
581      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
582      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
583      * @param spender address The address which will spend the funds
584      * @param value uint256 The amount of tokens to be spent
585      */
586     function approveAndCall(address spender, uint256 value) public returns (bool);
587 
588     /**
589      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
590      * and then call `onApprovalReceived` on spender.
591      * Beware that changing an allowance with this method brings the risk that someone may use both the old
592      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
593      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
594      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
595      * @param spender address The address which will spend the funds
596      * @param value uint256 The amount of tokens to be spent
597      * @param data bytes Additional data with no specified format, sent in call to `spender`
598      */
599     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool);
600 }
601 
602 /**
603  * @title IERC1363Receiver Interface
604  * @author Vittorio Minacori (https://github.com/vittominacori)
605  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
606  *  from ERC1363 token contracts as defined in
607  *  https://github.com/ethereum/EIPs/issues/1363
608  */
609 contract IERC1363Receiver {
610     /*
611      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
612      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
613      */
614 
615     /**
616      * @notice Handle the receipt of ERC1363 tokens
617      * @dev Any ERC1363 smart contract calls this function on the recipient
618      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
619      * transfer. Return of other than the magic value MUST result in the
620      * transaction being reverted.
621      * Note: the token contract address is always the message sender.
622      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
623      * @param from address The address which are token transferred from
624      * @param value uint256 The amount of tokens transferred
625      * @param data bytes Additional data with no specified format
626      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
627      *  unless throwing
628      */
629     function onTransferReceived(address operator, address from, uint256 value, bytes memory data) public returns (bytes4); // solhint-disable-line  max-line-length
630 }
631 
632 /**
633  * @title IERC1363Spender Interface
634  * @author Vittorio Minacori (https://github.com/vittominacori)
635  * @dev Interface for any contract that wants to support approveAndCall
636  *  from ERC1363 token contracts as defined in
637  *  https://github.com/ethereum/EIPs/issues/1363
638  */
639 contract IERC1363Spender {
640     /*
641      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
642      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
643      */
644 
645     /**
646      * @notice Handle the approval of ERC1363 tokens
647      * @dev Any ERC1363 smart contract calls this function on the recipient
648      * after an `approve`. This function MAY throw to revert and reject the
649      * approval. Return of other than the magic value MUST result in the
650      * transaction being reverted.
651      * Note: the token contract address is always the message sender.
652      * @param owner address The address which called `approveAndCall` function
653      * @param value uint256 The amount of tokens to be spent
654      * @param data bytes Additional data with no specified format
655      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
656      *  unless throwing
657      */
658     function onApprovalReceived(address owner, uint256 value, bytes memory data) public returns (bytes4);
659 }
660 
661 /**
662  * @title ERC1363
663  * @author Vittorio Minacori (https://github.com/vittominacori)
664  * @dev Implementation of an ERC1363 interface
665  */
666 contract ERC1363 is ERC20, IERC1363 {
667     using Address for address;
668 
669     /*
670      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
671      * 0x4bbee2df ===
672      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
673      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
674      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
675      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
676      */
677     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
678 
679     /*
680      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
681      * 0xfb9ec8ce ===
682      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
683      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
684      */
685     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
686 
687     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
688     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
689     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
690 
691     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
692     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
693     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
694 
695     constructor() public {
696         // register the supported interfaces to conform to ERC1363 via ERC165
697         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
698         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
699     }
700 
701     function transferAndCall(address to, uint256 value) public returns (bool) {
702         return transferAndCall(to, value, "");
703     }
704 
705     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool) {
706         require(transfer(to, value));
707         require(_checkAndCallTransfer(msg.sender, to, value, data));
708         return true;
709     }
710 
711     function transferFromAndCall(address from, address to, uint256 value) public returns (bool) {
712         return transferFromAndCall(from, to, value, "");
713     }
714 
715     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool) {
716         require(transferFrom(from, to, value));
717         require(_checkAndCallTransfer(from, to, value, data));
718         return true;
719     }
720 
721     function approveAndCall(address spender, uint256 value) public returns (bool) {
722         return approveAndCall(spender, value, "");
723     }
724 
725     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool) {
726         approve(spender, value);
727         require(_checkAndCallApprove(spender, value, data));
728         return true;
729     }
730 
731     /**
732      * @dev Internal function to invoke `onTransferReceived` on a target address
733      *  The call is not executed if the target address is not a contract
734      * @param from address Representing the previous owner of the given token value
735      * @param to address Target address that will receive the tokens
736      * @param value uint256 The amount mount of tokens to be transferred
737      * @param data bytes Optional data to send along with the call
738      * @return whether the call correctly returned the expected magic value
739      */
740     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
741         if (!to.isContract()) {
742             return false;
743         }
744         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
745             msg.sender, from, value, data
746         );
747         return (retval == _ERC1363_RECEIVED);
748     }
749 
750     /**
751      * @dev Internal function to invoke `onApprovalReceived` on a target address
752      *  The call is not executed if the target address is not a contract
753      * @param spender address The address which will spend the funds
754      * @param value uint256 The amount of tokens to be spent
755      * @param data bytes Optional data to send along with the call
756      * @return whether the call correctly returned the expected magic value
757      */
758     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
759         if (!spender.isContract()) {
760             return false;
761         }
762         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
763             msg.sender, value, data
764         );
765         return (retval == _ERC1363_APPROVED);
766     }
767 }
768 
769 contract YVRToken is ERC20Detailed, ERC1363 {
770   uint256 private INITIAL_SUPPLY = uint256(uint256(300000000) * uint256(1000000000000000000));
771 
772   constructor(string memory name,  string memory symbol,  uint8 decimals)
773     ERC20Detailed(name, symbol, decimals)
774     ERC1363()
775   public
776   {
777     _mint(msg.sender, INITIAL_SUPPLY);
778   }
779 }