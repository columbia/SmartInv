1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IERC20Permit} from '../interfaces/IERC20Permit.sol';
5 import {ERC20} from './ERC20.sol';
6 import {EIP712} from '@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol';
7 import {ECDSA} from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
8 import {Counters} from '@openzeppelin/contracts/utils/Counters.sol';
9 
10 abstract contract ERC20Permit is IERC20Permit, ERC20, EIP712 {
11     using Counters for Counters.Counter;
12 
13     mapping(address => Counters.Counter) private _nonces;
14 
15     // solhint-disable-next-line var-name-mixedcase
16     bytes32 private immutable _PERMIT_TYPEHASH =
17         keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)');
18 
19     /**
20      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
21      *
22      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
23      */
24     constructor(string memory name) EIP712(name, '1') {}
25 
26     /**
27      * @dev See {IERC20Permit-permit}.
28      */
29     function permit(
30         address owner,
31         address spender,
32         uint256 value,
33         uint256 deadline,
34         uint8 v,
35         bytes32 r,
36         bytes32 s
37     ) public virtual override {
38         require(block.timestamp <= deadline, 'E602');
39 
40         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
41 
42         bytes32 hash = _hashTypedDataV4(structHash);
43 
44         address signer = ECDSA.recover(hash, v, r, s);
45         require(signer == owner, 'E603');
46 
47         _approve(owner, spender, value);
48     }
49 
50     /**
51      * @dev See {IERC20Permit-nonces}.
52      */
53     function nonces(address owner) public view virtual override returns (uint256) {
54         return _nonces[owner].current();
55     }
56 
57     /**
58      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
59      */
60     // solhint-disable-next-line func-name-mixedcase
61     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
62         return _domainSeparatorV4();
63     }
64 
65     /**
66      * @dev "Consume a nonce": return the current value and increment.
67      *
68      * _Available since v4.1._
69      */
70     function _useNonce(address owner) internal virtual returns (uint256 current) {
71         Counters.Counter storage nonce = _nonces[owner];
72         current = nonce.current();
73         nonce.increment();
74     }
75 }
