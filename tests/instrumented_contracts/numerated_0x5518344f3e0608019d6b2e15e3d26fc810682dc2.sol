1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/AdventureHub.sol": {
5       "content": "// SPDX-License-Identifier: MIT\npragma solidity 0.8.9;\n\nimport \"@limit-break/achievements/contracts/IAchievements.sol\";\nimport \"limit-break-contracts/contracts/adventures/IAdventure.sol\";\nimport \"limit-break-contracts/contracts/adventures/IAdventurousERC721.sol\";\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\nimport \"@openzeppelin/contracts/token/ERC721/IERC721.sol\";\nimport \"@openzeppelin/contracts/utils/introspection/ERC165.sol\";\n\nerror AdventureKeyAlreadyActivated();\nerror AdventureKeyIsInactive();\nerror CallerNotTokenOwner();\nerror CannotSpecifyZeroAddressForAchievementsToken();\nerror NoMoreAdventureKeysCanBeActivated();\nerror NotAnAdventurousContract();\nerror NotAnERC721Contract();\nerror OnQuestEnteredCallbackTriggeredByAddressThatIsNotAnActiveAdventureKey();\nerror UnknownAdventureKey();\n\n/**\n * @title AdventureHub\n * @author Limit Break, Inc.\n * @notice An Adventure that is compatible with all adventure keys, unlocking crossover events with any partner game.\n */\ncontract AdventureHub is Ownable, ERC165, IAdventure {\n    \n    struct KeyState {\n        bool isKeyActive;\n        uint32 questId;\n        uint256 achievementId;\n    }\n\n    /// @dev Largest unsigned int 32 bit value\n    uint256 private constant MAX_UINT32 = type(uint32).max;\n\n    /// @dev Points to the soulbound achievements token.\n    /// Players earn soulbound achievement badges for entering games using their adventure keys.\n    IAchievements public immutable achievementsToken;\n\n    /// @dev The quest id of the adventure key that was most recently activated for the first time.\n    uint32 public lastQuestId;\n\n    /// @dev Maps an adventure key contract address to its key state (activation status and associated quest id)\n    mapping (address => KeyState) public adventureKeyStates;\n\n    /// @dev Maps a quest id to the adventure key contract address it is bound to\n    /// If needed, off-chain applications can enumerate over this mapping using `lastQuestId` as the upper bound\n    mapping (uint32 => address) public adventureKeyQuestIds;\n\n    /// @dev Emitted whenever an adventure key is activated or deactivated\n    event AdventureKeyActivationChanged(address indexed adventureKeyAddress, uint256 questId, uint256 achievementId, bool isActive);\n\n    constructor(address achievementsTokenAddress) {\n        if(achievementsTokenAddress == address(0)) {\n            revert CannotSpecifyZeroAddressForAchievementsToken();\n        }\n\n        achievementsToken = IAchievements(achievementsTokenAddress);\n    }\n\n    /// @notice Activates an adventure key for use with the Adventure Hub.\n    /// Throws when the caller is not the owner of this contract.\n    /// Throws when the number of previously activated adventure keys is equal to the maximum uint32 value.\n    /// Throws when the specified adventure key contract does not implement the IAdventurous interface.\n    /// Throws when the specified adventure key contract is already activated for use in the Adventure Hub.\n    /// Throws if AdventureHub MINTER_ROLE access is revoked on the achievements contract\n    ///\n    /// Postconditions:\n    /// The specified adventure key contract has been activated.  New entries into quests with adventure key are permitted.\n    /// `adventureKeyStates` mapping has been updated.\n    /// `lastQuestId` value has been incremented.\n    /// An achievement id has been reserved for users that enter the quest with the activated key.\n    ///\n    /// @dev The metadataURI parameter has no effect for re-activations of adventure keys.\n    /// If a key has already been activated, it is recommended to leave metadataURI blank.\n    function activateAdventureKey(address adventureKeyAddress, string calldata metadataURI) external onlyOwner {\n        if(!IERC165(adventureKeyAddress).supportsInterface(type(IAdventurous).interfaceId)) {\n            revert NotAnAdventurousContract();\n        }\n\n        if(!IERC165(adventureKeyAddress).supportsInterface(type(IERC721).interfaceId)) {\n            revert NotAnERC721Contract();\n        }\n\n        KeyState memory keyState = adventureKeyStates[adventureKeyAddress];\n\n        if(keyState.questId == 0) {\n            if(lastQuestId == MAX_UINT32) {\n                revert NoMoreAdventureKeysCanBeActivated();\n            }\n\n            unchecked {\n                uint32 questId = ++lastQuestId;\n                adventureKeyStates[adventureKeyAddress].questId = questId;\n                adventureKeyQuestIds[questId] = adventureKeyAddress;\n            }\n\n            adventureKeyStates[adventureKeyAddress].achievementId = achievementsToken.reserveAchievementId(metadataURI);\n        } else if(keyState.isKeyActive) {\n            revert AdventureKeyAlreadyActivated();\n        }\n\n        adventureKeyStates[adventureKeyAddress].isKeyActive = true;\n\n        emit AdventureKeyActivationChanged(adventureKeyAddress, adventureKeyStates[adventureKeyAddress].questId, adventureKeyStates[adventureKeyAddress].achievementId, true);\n    }\n\n    /// @notice Deactivates an adventure key, preventing new entries into quests using the deactivated key.\n    /// Players may still exit after the key is deactivated.\n    /// Throws when the caller is not the owner of this contract.\n    /// Throws when the adventure key address has never been activated, or is currently de-activated.\n    ///\n    /// Postconditions:\n    /// The specified adventure key contract has been de-activated.  New entries into quests with the de-activated\n    /// key will be disabled unless the key is re-activated.\n    function deactivateAdventureKey(address adventureKeyAddress) external onlyOwner {\n        KeyState memory keyState = adventureKeyStates[adventureKeyAddress];\n\n        if(!keyState.isKeyActive) {\n            revert AdventureKeyIsInactive();\n        }\n\n        adventureKeyStates[adventureKeyAddress].isKeyActive = false;\n\n        emit AdventureKeyActivationChanged(adventureKeyAddress, keyState.questId, keyState.achievementId, false);\n    }\n\n    /// @notice Enters the quest associated with the specified adventure key contract for the specified token id.\n    /// Throws when the owner of the adventure key is not the caller.\n    /// Throws when the adventure key address has never been activated, or is currently de-activated.\n    /// Throws when the AdventureHub is not currently whitelisted on the specified adventure key.\n    /// Throws when the AdventureHub has not been approved by user for adventures on the specified adventure key.\n    /// Throws when the specified token id on the specified adventure key is already in the quest.\n    ///\n    /// Postconditions:\n    /// The specified token id has entered the quest associated with the specified adventure key.\n    function enterQuestWithAdventureKey(address adventureKeyAddress, uint256 tokenId) external {\n        _requireCallerOwnsToken(adventureKeyAddress, tokenId);\n\n        KeyState storage keyState = adventureKeyStates[adventureKeyAddress];\n\n        if(!keyState.isKeyActive) {\n            revert AdventureKeyIsInactive();\n        }\n\n        IAdventurous(adventureKeyAddress).enterQuest(tokenId, keyState.questId);\n    }\n\n    /// @notice Exits the quest associated with the specified adventure key contract for the specified token id.\n    /// Throws when the owner of the adventure key is not the caller.\n    /// Throws when the adventure key address has never been activated.\n    /// Throws when the AdventureHub is not currently whitelisted on the specified adventure key.\n    /// Throws when the AdventureHub has not been approved by user for adventures on the specified adventure key.\n    /// Throws when the specified token id on the specified adventure key is no longer in the quest.\n    /// - This condition should be rare, and can only happen if the Adventure Hub is removed from the whitelist\n    ///   and re-whitelisted, presenting a limited window of opportunity to backdoor userExitQuest.\n    ///\n    /// Postconditions:\n    /// The specified token id has exited from the quest associated with the specified adventure key.\n    function exitQuestWithAdventureKey(address adventureKeyAddress, uint256 tokenId) external {\n        _requireCallerOwnsToken(adventureKeyAddress, tokenId);\n\n        KeyState storage keyState = adventureKeyStates[adventureKeyAddress];\n\n        if(keyState.questId == 0) {\n            revert UnknownAdventureKey();\n        }\n\n        IAdventurous(adventureKeyAddress).exitQuest(tokenId, keyState.questId);\n    }\n\n    /// @dev Callback that mints a soulbound achievement to the adventurer that entered the quest if they haven't received the achievement previously.\n    function onQuestEntered(address adventurer, uint256 /*tokenId*/, uint256 /*questId*/) external override {\n        KeyState storage senderKeyState = adventureKeyStates[_msgSender()];\n\n        if(!senderKeyState.isKeyActive) {\n            revert OnQuestEnteredCallbackTriggeredByAddressThatIsNotAnActiveAdventureKey();\n        }\n\n        if(achievementsToken.balanceOf(adventurer, senderKeyState.achievementId) == 0) {\n            achievementsToken.mint(adventurer, senderKeyState.achievementId, 1);\n        }\n    }\n\n    /// @dev onQuestExited callback does nothing for this contract, because there is no state to synchronize\n    function onQuestExited(address /*adventurer*/, uint256 /*tokenId*/, uint256 /*questId*/, uint256 /*questStartTimestamp*/) external override view {}\n\n    /// @dev Enumerates all tokens that the specified player currently has entered into the quest.\n    /// Never use this function in a transaction context - it is fine for a read-only query for \n    /// external applications, but will consume a lot of gas when used in a transaction.\n    /// Throws if specified adventure key address has never been activated.\n    function findQuestingTokensByAdventureKeyAndPlayer(address adventureKeyAddress, address player, uint256 tokenIdPageStart, uint256 tokenIdPageEnd) external view returns (uint256[] memory tokenIdsInQuest) {\n        uint256 questId = adventureKeyStates[adventureKeyAddress].questId;\n\n        if(questId == 0) {\n            revert UnknownAdventureKey();\n        }\n\n        IAdventurousERC721 adventureKey = IAdventurousERC721(adventureKeyAddress);\n        \n        unchecked {\n            // First, find all the token ids owned by the player\n            uint256 ownerBalance = adventureKey.balanceOf(player);\n            uint256[] memory ownedTokenIds = new uint256[](ownerBalance);\n            uint256 tokenIndex = 0;\n            for(uint256 tokenId = tokenIdPageStart; tokenId <= tokenIdPageEnd; ++tokenId) {\n                try adventureKey.ownerOf(tokenId) returns (address ownerOfToken) {\n                    if(ownerOfToken == player) {\n                        ownedTokenIds[tokenIndex++] = tokenId;\n                    }\n                } catch {}\n                \n                if(tokenIndex == ownerBalance || tokenId == type(uint256).max) {\n                    break;\n                }\n            }\n\n            // For each owned token id, check the quest count\n            // When 1 or greater, the spirit is engaged in a quest on this adventure.\n            address thisAddress = address(this);\n            uint256 numberOfTokenIdsOnQuest = 0;\n            for(uint256 i = 0; i < ownerBalance; ++i) {\n                uint256 ownedTokenId = ownedTokenIds[i];\n                \n                if(ownedTokenId > 0) {\n                    (bool isPartipatingInQuest,,) = adventureKey.isParticipatingInQuest(ownedTokenId, thisAddress, questId);\n                    if(isPartipatingInQuest) {\n                        ++numberOfTokenIdsOnQuest;\n                    }\n                }\n            }\n\n            // Finally, make one more pass and populate the player quests return array\n            uint256 questIndex = 0;\n            tokenIdsInQuest = new uint256[](numberOfTokenIdsOnQuest);\n    \n            for(uint256 i = 0; i < ownerBalance; ++i) {\n                uint256 ownedTokenId = ownedTokenIds[i];\n                if(ownedTokenId > 0) {\n                    (bool isPartipatingInQuest,,) = adventureKey.isParticipatingInQuest(ownedTokenId, thisAddress, questId);\n                    if(isPartipatingInQuest) {\n                        tokenIdsInQuest[questIndex] = ownedTokenId;\n                        ++questIndex;\n                    }\n                }\n    \n                if(questIndex == numberOfTokenIdsOnQuest) {\n                    break;\n                }\n            }\n        }\n\n        return tokenIdsInQuest;\n    }\n\n    /// @dev Adventure Keys are always locked/non-transferrable while they are participating in Adventure Hub quests\n    function questsLockTokens() external override pure returns (bool) {\n        return false;\n    }\n\n    /// @dev ERC-165 interface support\n    function supportsInterface(bytes4 interfaceId) public view virtual override (ERC165, IERC165) returns (bool) {\n        return interfaceId == type(IAdventure).interfaceId || super.supportsInterface(interfaceId);\n    }\n\n    /// @dev Validates that the caller owns the specified token for the specified token contract address\n    /// Throws when the caller does not own the specified token.\n    function _requireCallerOwnsToken(address adventureKeyAddress, uint256 tokenId) internal view {\n        if(IERC721(adventureKeyAddress).ownerOf(tokenId) != _msgSender()) {\n            revert CallerNotTokenOwner();\n        }\n    }\n}"
6     },
7     "limit-break-contracts/contracts/adventures/IAdventure.sol": {
8       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.4;\n\nimport \"@openzeppelin/contracts/utils/introspection/IERC165.sol\";\n\n/**\n * @title IAdventure\n * @author Limit Break, Inc.\n * @notice The base interface that all `Adventure` contracts must conform to.\n * @dev All contracts that implement the adventure/quest system and interact with an {IAdventurous} token are required to implement this interface.\n */\ninterface IAdventure is IERC165 {\n\n    /**\n     * @dev Returns whether or not quests on this adventure lock tokens.\n     * Developers of adventure contract should ensure that this is immutable \n     * after deployment of the adventure contract.  Failure to do so\n     * can lead to error that deadlock token transfers.\n     */\n    function questsLockTokens() external view returns (bool);\n\n    /**\n     * @dev A callback function that AdventureERC721 must invoke when a quest has been successfully entered.\n     * Throws if the caller is not an expected AdventureERC721 contract designed to work with the Adventure.\n     * Not permitted to throw in any other case, as this could lead to tokens being locked in quests.\n     */\n    function onQuestEntered(address adventurer, uint256 tokenId, uint256 questId) external;\n\n    /**\n     * @dev A callback function that AdventureERC721 must invoke when a quest has been successfully exited.\n     * Throws if the caller is not an expected AdventureERC721 contract designed to work with the Adventure.\n     * Not permitted to throw in any other case, as this could lead to tokens being locked in quests.\n     */\n    function onQuestExited(address adventurer, uint256 tokenId, uint256 questId, uint256 questStartTimestamp) external;\n}\n"
9     },
10     "@limit-break/achievements/contracts/IAchievements.sol": {
11       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\nimport \"@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol\";\n\n/**\n * @title IAchievements\n * @author Limit Break, Inc.\n * @notice Interface for the Achievements token contract\n */\ninterface IAchievements is IERC1155MetadataURI {\n \n    /// @dev Reserves an achievement id and associates the achievement id with a single allowed minter.\n    function reserveAchievementId(string calldata metadataURI) external returns (uint256);\n\n    /// @dev Mints an achievement of type `id` to the `to` address.\n    function mint(address to, uint256 id, uint256 amount) external;\n\n    /// @dev Batch mints achievements to the `to` address.\n    function mintBatch(address to, uint256[] calldata ids, uint256[] calldata amounts) external;\n}"
12     },
13     "limit-break-contracts/contracts/adventures/IAdventurousERC721.sol": {
14       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.4;\n\nimport \"./IAdventurous.sol\";\nimport \"@openzeppelin/contracts/token/ERC721/IERC721.sol\";\n\n/**\n * @title IAdventurousERC721\n * @author Limit Break, Inc.\n * @notice Combines all {IAdventurous} and all {IERC721} functionality into a single, unified interface.\n * @dev This interface may be used as a convenience to interact with tokens that support both interface standards.\n */\ninterface IAdventurousERC721 is IERC721, IAdventurous {\n\n}"
15     },
16     "@openzeppelin/contracts/access/Ownable.sol": {
17       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
18     },
19     "@openzeppelin/contracts/token/ERC721/IERC721.sol": {
20       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../../utils/introspection/IERC165.sol\";\n\n/**\n * @dev Required interface of an ERC721 compliant contract.\n */\ninterface IERC721 is IERC165 {\n    /**\n     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n\n    /**\n     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.\n     */\n    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n\n    /**\n     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.\n     */\n    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n\n    /**\n     * @dev Returns the number of tokens in ``owner``'s account.\n     */\n    function balanceOf(address owner) external view returns (uint256 balance);\n\n    /**\n     * @dev Returns the owner of the `tokenId` token.\n     *\n     * Requirements:\n     *\n     * - `tokenId` must exist.\n     */\n    function ownerOf(uint256 tokenId) external view returns (address owner);\n\n    /**\n     * @dev Safely transfers `tokenId` token from `from` to `to`.\n     *\n     * Requirements:\n     *\n     * - `from` cannot be the zero address.\n     * - `to` cannot be the zero address.\n     * - `tokenId` token must exist and be owned by `from`.\n     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n     *\n     * Emits a {Transfer} event.\n     */\n    function safeTransferFrom(\n        address from,\n        address to,\n        uint256 tokenId,\n        bytes calldata data\n    ) external;\n\n    /**\n     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients\n     * are aware of the ERC721 protocol to prevent tokens from being forever locked.\n     *\n     * Requirements:\n     *\n     * - `from` cannot be the zero address.\n     * - `to` cannot be the zero address.\n     * - `tokenId` token must exist and be owned by `from`.\n     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.\n     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n     *\n     * Emits a {Transfer} event.\n     */\n    function safeTransferFrom(\n        address from,\n        address to,\n        uint256 tokenId\n    ) external;\n\n    /**\n     * @dev Transfers `tokenId` token from `from` to `to`.\n     *\n     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.\n     *\n     * Requirements:\n     *\n     * - `from` cannot be the zero address.\n     * - `to` cannot be the zero address.\n     * - `tokenId` token must be owned by `from`.\n     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 tokenId\n    ) external;\n\n    /**\n     * @dev Gives permission to `to` to transfer `tokenId` token to another account.\n     * The approval is cleared when the token is transferred.\n     *\n     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.\n     *\n     * Requirements:\n     *\n     * - The caller must own the token or be an approved operator.\n     * - `tokenId` must exist.\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address to, uint256 tokenId) external;\n\n    /**\n     * @dev Approve or remove `operator` as an operator for the caller.\n     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.\n     *\n     * Requirements:\n     *\n     * - The `operator` cannot be the caller.\n     *\n     * Emits an {ApprovalForAll} event.\n     */\n    function setApprovalForAll(address operator, bool _approved) external;\n\n    /**\n     * @dev Returns the account approved for `tokenId` token.\n     *\n     * Requirements:\n     *\n     * - `tokenId` must exist.\n     */\n    function getApproved(uint256 tokenId) external view returns (address operator);\n\n    /**\n     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.\n     *\n     * See {setApprovalForAll}\n     */\n    function isApprovedForAll(address owner, address operator) external view returns (bool);\n}\n"
21     },
22     "@openzeppelin/contracts/utils/introspection/ERC165.sol": {
23       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)\n\npragma solidity ^0.8.0;\n\nimport \"./IERC165.sol\";\n\n/**\n * @dev Implementation of the {IERC165} interface.\n *\n * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check\n * for the additional interface id that will be supported. For example:\n *\n * ```solidity\n * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);\n * }\n * ```\n *\n * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.\n */\nabstract contract ERC165 is IERC165 {\n    /**\n     * @dev See {IERC165-supportsInterface}.\n     */\n    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n        return interfaceId == type(IERC165).interfaceId;\n    }\n}\n"
24     },
25     "@openzeppelin/contracts/utils/introspection/IERC165.sol": {
26       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC165 standard, as defined in the\n * https://eips.ethereum.org/EIPS/eip-165[EIP].\n *\n * Implementers can declare support of contract interfaces, which can then be\n * queried by others ({ERC165Checker}).\n *\n * For an implementation, see {ERC165}.\n */\ninterface IERC165 {\n    /**\n     * @dev Returns true if this contract implements the interface defined by\n     * `interfaceId`. See the corresponding\n     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n     * to learn more about how these ids are created.\n     *\n     * This function call must use less than 30 000 gas.\n     */\n    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n}\n"
27     },
28     "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol": {
29       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../IERC1155.sol\";\n\n/**\n * @dev Interface of the optional ERC1155MetadataExtension interface, as defined\n * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].\n *\n * _Available since v3.1._\n */\ninterface IERC1155MetadataURI is IERC1155 {\n    /**\n     * @dev Returns the URI for token type `id`.\n     *\n     * If the `\\{id\\}` substring is present in the URI, it must be replaced by\n     * clients with the actual token type ID.\n     */\n    function uri(uint256 id) external view returns (string memory);\n}\n"
30     },
31     "@openzeppelin/contracts/token/ERC1155/IERC1155.sol": {
32       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../../utils/introspection/IERC165.sol\";\n\n/**\n * @dev Required interface of an ERC1155 compliant contract, as defined in the\n * https://eips.ethereum.org/EIPS/eip-1155[EIP].\n *\n * _Available since v3.1._\n */\ninterface IERC1155 is IERC165 {\n    /**\n     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.\n     */\n    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);\n\n    /**\n     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all\n     * transfers.\n     */\n    event TransferBatch(\n        address indexed operator,\n        address indexed from,\n        address indexed to,\n        uint256[] ids,\n        uint256[] values\n    );\n\n    /**\n     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to\n     * `approved`.\n     */\n    event ApprovalForAll(address indexed account, address indexed operator, bool approved);\n\n    /**\n     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.\n     *\n     * If an {URI} event was emitted for `id`, the standard\n     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value\n     * returned by {IERC1155MetadataURI-uri}.\n     */\n    event URI(string value, uint256 indexed id);\n\n    /**\n     * @dev Returns the amount of tokens of token type `id` owned by `account`.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     */\n    function balanceOf(address account, uint256 id) external view returns (uint256);\n\n    /**\n     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.\n     *\n     * Requirements:\n     *\n     * - `accounts` and `ids` must have the same length.\n     */\n    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)\n        external\n        view\n        returns (uint256[] memory);\n\n    /**\n     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,\n     *\n     * Emits an {ApprovalForAll} event.\n     *\n     * Requirements:\n     *\n     * - `operator` cannot be the caller.\n     */\n    function setApprovalForAll(address operator, bool approved) external;\n\n    /**\n     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.\n     *\n     * See {setApprovalForAll}.\n     */\n    function isApprovedForAll(address account, address operator) external view returns (bool);\n\n    /**\n     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.\n     *\n     * Emits a {TransferSingle} event.\n     *\n     * Requirements:\n     *\n     * - `to` cannot be the zero address.\n     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.\n     * - `from` must have a balance of tokens of type `id` of at least `amount`.\n     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the\n     * acceptance magic value.\n     */\n    function safeTransferFrom(\n        address from,\n        address to,\n        uint256 id,\n        uint256 amount,\n        bytes calldata data\n    ) external;\n\n    /**\n     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.\n     *\n     * Emits a {TransferBatch} event.\n     *\n     * Requirements:\n     *\n     * - `ids` and `amounts` must have the same length.\n     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the\n     * acceptance magic value.\n     */\n    function safeBatchTransferFrom(\n        address from,\n        address to,\n        uint256[] calldata ids,\n        uint256[] calldata amounts,\n        bytes calldata data\n    ) external;\n}\n"
33     },
34     "limit-break-contracts/contracts/adventures/IAdventurous.sol": {
35       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.4;\n\nimport \"./Quest.sol\";\nimport \"@openzeppelin/contracts/utils/introspection/IERC165.sol\";\n\n/**\n * @title IAdventurous\n * @author Limit Break, Inc.\n * @notice The base interface that all `Adventurous` token contracts must conform to in order to support adventures and quests.\n * @dev All contracts that support adventures and quests are required to implement this interface.\n */\ninterface IAdventurous is IERC165 {\n\n    /**\n     * @dev Emitted when a token enters or exits a quest\n     */\n    event QuestUpdated(uint256 indexed tokenId, address indexed tokenOwner, address indexed adventure, uint256 questId, bool active, bool booted);\n\n    /**\n     * @notice Transfers a player's token if they have opted into an authorized, whitelisted adventure.\n     */\n    function adventureTransferFrom(address from, address to, uint256 tokenId) external;\n\n    /**\n     * @notice Safe transfers a player's token if they have opted into an authorized, whitelisted adventure.\n     */\n    function adventureSafeTransferFrom(address from, address to, uint256 tokenId) external;\n\n    /**\n     * @notice Burns a player's token if they have opted into an authorized, whitelisted adventure.\n     */\n    function adventureBurn(uint256 tokenId) external;\n\n    /**\n     * @notice Enters a player's token into a quest if they have opted into an authorized, whitelisted adventure.\n     */\n    function enterQuest(uint256 tokenId, uint256 questId) external;\n\n    /**\n     * @notice Exits a player's token from a quest if they have opted into an authorized, whitelisted adventure.\n     */\n    function exitQuest(uint256 tokenId, uint256 questId) external;\n\n    /**\n     * @notice Returns the number of quests a token is actively participating in for a specified adventure\n     */\n    function getQuestCount(uint256 tokenId, address adventure) external view returns (uint256);\n\n    /**\n     * @notice Returns the amount of time a token has been participating in the specified quest\n     */\n    function getTimeOnQuest(uint256 tokenId, address adventure, uint256 questId) external view returns (uint256);\n\n    /**\n     * @notice Returns whether or not a token is currently participating in the specified quest as well as the time it was started and the quest index\n     */\n    function isParticipatingInQuest(uint256 tokenId, address adventure, uint256 questId) external view returns (bool participatingInQuest, uint256 startTimestamp, uint256 index);\n\n    /**\n     * @notice Returns a list of all active quests for the specified token id and adventure\n     */\n    function getActiveQuests(uint256 tokenId, address adventure) external view returns (Quest[] memory activeQuests);\n}\n"
36     },
37     "limit-break-contracts/contracts/adventures/Quest.sol": {
38       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.4;\n\n/**\n * @title Quest\n * @author Limit Break, Inc.\n * @notice Quest data structure for {IAdventurous} contracts.\n */\nstruct Quest {\n    bool isActive;\n    uint32 questId;\n    uint64 startTimestamp;\n    uint32 arrayIndex;\n}"
39     },
40     "@openzeppelin/contracts/utils/Context.sol": {
41       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
42     }
43   },
44   "settings": {
45     "optimizer": {
46       "enabled": true,
47       "runs": 1500
48     },
49     "outputSelection": {
50       "*": {
51         "*": [
52           "evm.bytecode",
53           "evm.deployedBytecode",
54           "devdoc",
55           "userdoc",
56           "metadata",
57           "abi"
58         ]
59       }
60     },
61     "libraries": {}
62   }
63 }}