pragma solidity ^0.5.4;

/**
 * ERC20 contract interface.
 */
contract ERC20 {
    function totalSupply() public view returns (uint);
    function decimals() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
}

/**
 * @title Module
 * @dev Interface for a module. 
 * A module MUST implement the addModule() method to ensure that a wallet with at least one module
 * can never end up in a "frozen" state.
 * @author Julien Niset - <julien@argent.xyz>
 */
interface Module {
    function init(BaseWallet _wallet) external;
    function addModule(BaseWallet _wallet, Module _module) external;
    function recoverToken(address _token) external;
}

/**
 * @title BaseWallet
 * @dev Simple modular wallet that authorises modules to call its invoke() method.
 * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
 * @author Julien Niset - <julien@argent.xyz>
 */
contract BaseWallet {
    address public implementation;
    address public owner;
    mapping (address => bool) public authorised;
    mapping (bytes4 => address) public enabled;
    uint public modules;
    function init(address _owner, address[] calldata _modules) external;
    function authoriseModule(address _module, bool _value) external;
    function enableStaticCall(address _module, bytes4 _method) external;
    function setOwner(address _newOwner) external;
    function invoke(address _target, uint _value, bytes calldata _data) external returns (bytes memory _result);
}

/**
 * @title ModuleRegistry
 * @dev Registry of authorised modules. 
 * Modules must be registered before they can be authorised on a wallet.
 * @author Julien Niset - <julien@argent.xyz>
 */
contract ModuleRegistry {
    function registerModule(address _module, bytes32 _name) external;
    function deregisterModule(address _module) external;
    function registerUpgrader(address _upgrader, bytes32 _name) external;
    function deregisterUpgrader(address _upgrader) external;
    function recoverToken(address _token) external;
    function moduleInfo(address _module) external view returns (bytes32);
    function upgraderInfo(address _upgrader) external view returns (bytes32);
    function isRegisteredModule(address _module) external view returns (bool);
    function isRegisteredModule(address[] calldata _modules) external view returns (bool);
    function isRegisteredUpgrader(address _upgrader) external view returns (bool);
}

contract TokenPriceProvider {
    mapping(address => uint256) public cachedPrices;
    function setPrice(ERC20 _token, uint256 _price) public;
    function setPriceForTokenList(ERC20[] calldata _tokens, uint256[] calldata _prices) external;
    function getEtherValue(uint256 _amount, address _token) external view returns (uint256);
}

/**
 * @title GuardianStorage
 * @dev Contract storing the state of wallets related to guardians and lock.
 * The contract only defines basic setters and getters with no logic. Only modules authorised
 * for a wallet can modify its state.
 * @author Julien Niset - <julien@argent.xyz>
 * @author Olivier Van Den Biggelaar - <olivier@argent.xyz>
 */
contract GuardianStorage {
    function addGuardian(BaseWallet _wallet, address _guardian) external;
    function revokeGuardian(BaseWallet _wallet, address _guardian) external;
    function guardianCount(BaseWallet _wallet) external view returns (uint256);
    function getGuardians(BaseWallet _wallet) external view returns (address[] memory);
    function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool);
    function setLock(BaseWallet _wallet, uint256 _releaseAfter) external;
    function isLocked(BaseWallet _wallet) external view returns (bool);
    function getLock(BaseWallet _wallet) external view returns (uint256);
    function getLocker(BaseWallet _wallet) external view returns (address);
}

/**
 * @title TransferStorage
 * @dev Contract storing the state of wallets related to transfers (limit and whitelist).
 * The contract only defines basic setters and getters with no logic. Only modules authorised
 * for a wallet can modify its state.
 * @author Julien Niset - <julien@argent.xyz>
 */
contract TransferStorage {
    function setWhitelist(BaseWallet _wallet, address _target, uint256 _value) external;
    function getWhitelist(BaseWallet _wallet, address _target) external view returns (uint256);
}

/**
 * @title Interface for a contract that can invest tokens in order to earn an interest.
 * @author Julien Niset - <julien@argent.xyz>
 */
interface Invest {

    event InvestmentAdded(address indexed _wallet, address _token, uint256 _invested, uint256 _period);
    event InvestmentRemoved(address indexed _wallet, address _token, uint256 _fraction);

    function addInvestment(
        BaseWallet _wallet, 
        address _token, 
        uint256 _amount, 
        uint256 _period
    ) 
        external
        returns (uint256 _invested);

    function removeInvestment(
        BaseWallet _wallet, 
        address _token, 
        uint256 _fraction
    ) 
        external;

    function getInvestment(
        BaseWallet _wallet,
        address _token
    )
        external
        view
        returns (uint256 _tokenValue, uint256 _periodEnd);
}

contract VatLike {
    function can(address, address) public view returns (uint);
    function dai(address) public view returns (uint);
    function hope(address) public;
}

contract JoinLike {
    function gem() public returns (GemLike);
    function dai() public returns (GemLike);
    function join(address, uint) public;
    function exit(address, uint) public;
    VatLike public vat;
}

contract PotLike {
    function chi() public view returns (uint);
    function pie(address) public view returns (uint);
    function drip() public;
}

contract ScdMcdMigration {
    function swapSaiToDai(uint wad) external;
    function swapDaiToSai(uint wad) external;
    JoinLike public saiJoin;
    JoinLike public wethJoin;
    JoinLike public daiJoin;
}

contract GemLike {
    function balanceOf(address) public view returns (uint);
    function transferFrom(address, address, uint) public returns (bool);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }

    /**
    * @dev Returns ceil(a / b).
    */
    function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        if(a % b == 0) {
            return c;
        }
        else {
            return c + 1;
        }
    }
}

/**
 * @title BaseModule
 * @dev Basic module that contains some methods common to all modules.
 * @author Julien Niset - <julien@argent.im>
 */
contract BaseModule is Module {

    // Empty calldata
    bytes constant internal EMPTY_BYTES = "";

    // The adddress of the module registry.
    ModuleRegistry internal registry;
    // The address of the Guardian storage
    GuardianStorage internal guardianStorage;

    /**
     * @dev Throws if the wallet is locked.
     */
    modifier onlyWhenUnlocked(BaseWallet _wallet) {
        // solium-disable-next-line security/no-block-members
        require(!guardianStorage.isLocked(_wallet), "BM: wallet must be unlocked");
        _;
    }

    event ModuleCreated(bytes32 name);
    event ModuleInitialised(address wallet);

    constructor(ModuleRegistry _registry, GuardianStorage _guardianStorage, bytes32 _name) public {
        registry = _registry;
        guardianStorage = _guardianStorage;
        emit ModuleCreated(_name);
    }

    /**
     * @dev Throws if the sender is not the target wallet of the call.
     */
    modifier onlyWallet(BaseWallet _wallet) {
        require(msg.sender == address(_wallet), "BM: caller must be wallet");
        _;
    }

    /**
     * @dev Throws if the sender is not the owner of the target wallet or the module itself.
     */
    modifier onlyWalletOwner(BaseWallet _wallet) {
        require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
        _;
    }

    /**
     * @dev Throws if the sender is not the owner of the target wallet.
     */
    modifier strictOnlyWalletOwner(BaseWallet _wallet) {
        require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
        _;
    }

    /**
     * @dev Inits the module for a wallet by logging an event.
     * The method can only be called by the wallet itself.
     * @param _wallet The wallet.
     */
    function init(BaseWallet _wallet) public onlyWallet(_wallet) {
        emit ModuleInitialised(address(_wallet));
    }

    /**
     * @dev Adds a module to a wallet. First checks that the module is registered.
     * @param _wallet The target wallet.
     * @param _module The modules to authorise.
     */
    function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
        require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
        _wallet.authoriseModule(address(_module), true);
    }

    /**
    * @dev Utility method enbaling anyone to recover ERC20 token sent to the
    * module by mistake and transfer them to the Module Registry. 
    * @param _token The token to recover.
    */
    function recoverToken(address _token) external {
        uint total = ERC20(_token).balanceOf(address(this));
        ERC20(_token).transfer(address(registry), total);
    }

    /**
     * @dev Helper method to check if an address is the owner of a target wallet.
     * @param _wallet The target wallet.
     * @param _addr The address.
     */
    function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
        return _wallet.owner() == _addr;
    }

    /**
     * @dev Helper method to invoke a wallet.
     * @param _wallet The target wallet.
     * @param _to The target address for the transaction.
     * @param _value The value of the transaction.
     * @param _data The data of the transaction.
     */
    function invokeWallet(address _wallet, address _to, uint256 _value, bytes memory _data) internal returns (bytes memory _res) {
        bool success;
        // solium-disable-next-line security/no-call-value
        (success, _res) = _wallet.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _to, _value, _data));
        if(success && _res.length > 0) { //_res is empty if _wallet is an "old" BaseWallet that can't return output values
            (_res) = abi.decode(_res, (bytes));
        } else if (_res.length > 0) {
            // solium-disable-next-line security/no-inline-assembly
            assembly {
                returndatacopy(0, 0, returndatasize)
                revert(0, returndatasize)
            }
        } else if(!success) {
            revert("BM: wallet invoke reverted");
        }
    }
}

/**
 * @title RelayerModule
 * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer.
 * @author Julien Niset - <julien@argent.im>
 */
contract RelayerModule is BaseModule {

    uint256 constant internal BLOCKBOUND = 10000;

    mapping (address => RelayerConfig) public relayer;

    struct RelayerConfig {
        uint256 nonce;
        mapping (bytes32 => bool) executedTx;
    }

    event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);

    /**
     * @dev Throws if the call did not go through the execute() method.
     */
    modifier onlyExecute {
        require(msg.sender == address(this), "RM: must be called via execute()");
        _;
    }

    /* ***************** Abstract method ************************* */

    /**
    * @dev Gets the number of valid signatures that must be provided to execute a
    * specific relayed transaction.
    * @param _wallet The target wallet.
    * @param _data The data of the relayed transaction.
    * @return The number of required signatures.
    */
    function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);

    /**
    * @dev Validates the signatures provided with a relayed transaction.
    * The method MUST throw if one or more signatures are not valid.
    * @param _wallet The target wallet.
    * @param _data The data of the relayed transaction.
    * @param _signHash The signed hash representing the relayed transaction.
    * @param _signatures The signatures as a concatenated byte array.
    */
    function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool);

    /* ************************************************************ */

    /**
    * @dev Executes a relayed transaction.
    * @param _wallet The target wallet.
    * @param _data The data for the relayed transaction
    * @param _nonce The nonce used to prevent replay attacks.
    * @param _signatures The signatures as a concatenated byte array.
    * @param _gasPrice The gas price to use for the gas refund.
    * @param _gasLimit The gas limit to use for the gas refund.
    */
    function execute(
        BaseWallet _wallet,
        bytes calldata _data,
        uint256 _nonce,
        bytes calldata _signatures,
        uint256 _gasPrice,
        uint256 _gasLimit
    )
        external
        returns (bool success)
    {
        uint startGas = gasleft();
        bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
        require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
        require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
        uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
        if((requiredSignatures * 65) == _signatures.length) {
            if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
                if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
                    // solium-disable-next-line security/no-call-value
                    (success,) = address(this).call(_data);
                    refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
                }
            }
        }
        emit TransactionExecuted(address(_wallet), success, signHash);
    }

    /**
    * @dev Gets the current nonce for a wallet.
    * @param _wallet The target wallet.
    */
    function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
        return relayer[address(_wallet)].nonce;
    }

    /**
    * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
    * @param _from The starting address for the relayed transaction (should be the module)
    * @param _to The destination address for the relayed transaction (should be the wallet)
    * @param _value The value for the relayed transaction
    * @param _data The data for the relayed transaction
    * @param _nonce The nonce used to prevent replay attacks.
    * @param _gasPrice The gas price to use for the gas refund.
    * @param _gasLimit The gas limit to use for the gas refund.
    */
    function getSignHash(
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data,
        uint256 _nonce,
        uint256 _gasPrice,
        uint256 _gasLimit
    )
        internal
        pure
        returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
        ));
    }

    /**
    * @dev Checks if the relayed transaction is unique.
    * @param _wallet The target wallet.
    * @param _nonce The nonce
    * @param _signHash The signed hash of the transaction
    */
    function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
        if(relayer[address(_wallet)].executedTx[_signHash] == true) {
            return false;
        }
        relayer[address(_wallet)].executedTx[_signHash] = true;
        return true;
    }

    /**
    * @dev Checks that a nonce has the correct format and is valid.
    * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
    * @param _wallet The target wallet.
    * @param _nonce The nonce
    */
    function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
        if(_nonce <= relayer[address(_wallet)].nonce) {
            return false;
        }
        uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
        if(nonceBlock > block.number + BLOCKBOUND) {
            return false;
        }
        relayer[address(_wallet)].nonce = _nonce;
        return true;
    }

    /**
    * @dev Recovers the signer at a given position from a list of concatenated signatures.
    * @param _signedHash The signed hash
    * @param _signatures The concatenated signatures.
    * @param _index The index of the signature to recover.
    */
    function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
        uint8 v;
        bytes32 r;
        bytes32 s;
        // we jump 32 (0x20) as the first slot of bytes contains the length
        // we jump 65 (0x41) per signature
        // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
            s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
            v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
        }
        require(v == 27 || v == 28);
        return ecrecover(_signedHash, v, r, s);
    }

    /**
    * @dev Refunds the gas used to the Relayer. 
    * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
    * @param _wallet The target wallet.
    * @param _gasUsed The gas used.
    * @param _gasPrice The gas price for the refund.
    * @param _gasLimit The gas limit for the refund.
    * @param _signatures The number of signatures used in the call.
    * @param _relayer The address of the Relayer.
    */
    function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
        uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
        // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
        if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
            if(_gasPrice > tx.gasprice) {
                amount = amount * tx.gasprice;
            }
            else {
                amount = amount * _gasPrice;
            }
            invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
        }
    }

    /**
    * @dev Returns false if the refund is expected to fail.
    * @param _wallet The target wallet.
    * @param _gasUsed The expected gas used.
    * @param _gasPrice The expected gas price for the refund.
    */
    function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
        if(_gasPrice > 0
            && _signatures > 1
            && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
            return false;
        }
        return true;
    }

    /**
    * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
    * as the wallet passed as the input of the execute() method. 
    @return false if the addresses are different.
    */
    function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
        require(_data.length >= 36, "RM: Invalid dataWallet");
        address dataWallet;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            //_data = {length:32}{sig:4}{_wallet:32}{...}
            dataWallet := mload(add(_data, 0x24))
        }
        return dataWallet == _wallet;
    }

    /**
    * @dev Parses the data to extract the method signature.
    */
    function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
        require(_data.length >= 4, "RM: Invalid functionPrefix");
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            prefix := mload(add(_data, 0x20))
        }
    }
}

/**
 * @title OnlyOwnerModule
 * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
 * must be called with one signature frm the owner.
 * @author Julien Niset - <julien@argent.im>
 */
contract OnlyOwnerModule is BaseModule, RelayerModule {

    // bytes4 private constant IS_ONLY_OWNER_MODULE = bytes4(keccak256("isOnlyOwnerModule()"));

   /**
    * @dev Returns a constant that indicates that the module is an OnlyOwnerModule.
    * @return The constant bytes4(keccak256("isOnlyOwnerModule()"))
    */
    function isOnlyOwnerModule() external pure returns (bytes4) {
        // return IS_ONLY_OWNER_MODULE;
        return this.isOnlyOwnerModule.selector;
    }

    /**
     * @dev Adds a module to a wallet. First checks that the module is registered.
     * Unlike its overrided parent, this method can be called via the RelayerModule's execute()
     * @param _wallet The target wallet.
     * @param _module The modules to authorise.
     */
    function addModule(BaseWallet _wallet, Module _module) external onlyWalletOwner(_wallet) {
        require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
        _wallet.authoriseModule(address(_module), true);
    }

    // *************** Implementation of RelayerModule methods ********************* //

    // Overrides to use the incremental nonce and save some gas
    function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 /* _signHash */) internal returns (bool) {
        return checkAndUpdateNonce(_wallet, _nonce);
    }

    function validateSignatures(
        BaseWallet _wallet,
        bytes memory /* _data */,
        bytes32 _signHash,
        bytes memory _signatures
    )
        internal
        view
        returns (bool)
    {
        address signer = recoverSigner(_signHash, _signatures, 0);
        return isOwner(_wallet, signer); // "OOM: signer must be owner"
    }

    function getRequiredSignatures(BaseWallet /* _wallet */, bytes memory /* _data */) internal view returns (uint256) {
        return 1;
    }
}

/**
 * @title LimitManager
 * @dev Module to manage a daily spending limit
 * @author Julien Niset - <julien@argent.im>
 */
contract LimitManager is BaseModule {

    // large limit when the limit can be considered disabled
    uint128 constant private LIMIT_DISABLED = uint128(-1); // 3.40282366920938463463374607431768211455e+38

    using SafeMath for uint256;

    struct LimitManagerConfig {
        // The daily limit
        Limit limit;
        // The current usage
        DailySpent dailySpent;
    }

    struct Limit {
        // the current limit
        uint128 current;
        // the pending limit if any
        uint128 pending;
        // when the pending limit becomes the current limit
        uint64 changeAfter;
    }

    struct DailySpent {
        // The amount already spent during the current period
        uint128 alreadySpent;
        // The end of the current period
        uint64 periodEnd;
    }

    // wallet specific storage
    mapping (address => LimitManagerConfig) internal limits;
    // The default limit
    uint256 public defaultLimit;

    // *************** Events *************************** //

    event LimitChanged(address indexed wallet, uint indexed newLimit, uint64 indexed startAfter);

    // *************** Constructor ********************** //

    constructor(uint256 _defaultLimit) public {
        defaultLimit = _defaultLimit;
    }

    // *************** External/Public Functions ********************* //

    /**
     * @dev Inits the module for a wallet by setting the limit to the default value.
     * @param _wallet The target wallet.
     */
    function init(BaseWallet _wallet) public onlyWallet(_wallet) {
        Limit storage limit = limits[address(_wallet)].limit;
        if(limit.current == 0 && limit.changeAfter == 0) {
            limit.current = uint128(defaultLimit);
        }
    }

    // *************** Internal Functions ********************* //

    /**
     * @dev Changes the daily limit.
     * The limit is expressed in ETH and the change is pending for the security period.
     * @param _wallet The target wallet.
     * @param _newLimit The new limit.
     * @param _securityPeriod The security period.
     */
    function changeLimit(BaseWallet _wallet, uint256 _newLimit, uint256 _securityPeriod) internal {
        Limit storage limit = limits[address(_wallet)].limit;
        // solium-disable-next-line security/no-block-members
        uint128 current = (limit.changeAfter > 0 && limit.changeAfter < now) ? limit.pending : limit.current;
        limit.current = current;
        limit.pending = uint128(_newLimit);
        // solium-disable-next-line security/no-block-members
        limit.changeAfter = uint64(now.add(_securityPeriod));
        // solium-disable-next-line security/no-block-members
        emit LimitChanged(address(_wallet), _newLimit, uint64(now.add(_securityPeriod)));
    }

     /**
     * @dev Disable the daily limit.
     * The change is pending for the security period.
     * @param _wallet The target wallet.
     * @param _securityPeriod The security period.
     */
    function disableLimit(BaseWallet _wallet, uint256 _securityPeriod) internal {
        changeLimit(_wallet, LIMIT_DISABLED, _securityPeriod);
    }

    /**
    * @dev Gets the current daily limit for a wallet.
    * @param _wallet The target wallet.
    * @return the current limit expressed in ETH.
    */
    function getCurrentLimit(BaseWallet _wallet) public view returns (uint256 _currentLimit) {
        Limit storage limit = limits[address(_wallet)].limit;
        _currentLimit = uint256(currentLimit(limit.current, limit.pending, limit.changeAfter));
    }

    /**
    * @dev Returns whether the daily limit is disabled for a wallet.
    * @param _wallet The target wallet.
    * @return true if the daily limit is disabled, false otherwise.
    */
    function isLimitDisabled(BaseWallet _wallet) public view returns (bool _limitDisabled) {
        uint256 currentLimit = getCurrentLimit(_wallet);
        _limitDisabled = currentLimit == LIMIT_DISABLED;
    }

    /**
    * @dev Gets a pending limit for a wallet if any.
    * @param _wallet The target wallet.
    * @return the pending limit (in ETH) and the time at chich it will become effective.
    */
    function getPendingLimit(BaseWallet _wallet) external view returns (uint256 _pendingLimit, uint64 _changeAfter) {
        Limit storage limit = limits[address(_wallet)].limit;
        // solium-disable-next-line security/no-block-members
        return ((now < limit.changeAfter)? (uint256(limit.pending), limit.changeAfter) : (0,0));
    }

    /**
    * @dev Gets the amount of tokens that has not yet been spent during the current period.
    * @param _wallet The target wallet.
    * @return the amount of tokens (in ETH) that has not been spent yet and the end of the period.
    */
    function getDailyUnspent(BaseWallet _wallet) external view returns (uint256 _unspent, uint64 _periodEnd) {
        uint256 limit = getCurrentLimit(_wallet);
        DailySpent storage expense = limits[address(_wallet)].dailySpent;
        // solium-disable-next-line security/no-block-members
        if(now > expense.periodEnd) {
            _unspent = limit;
            // solium-disable-next-line security/no-block-members
            _periodEnd = uint64(now + 24 hours);
        }
        else {
            _periodEnd = expense.periodEnd;
            if(expense.alreadySpent < limit) {
                _unspent = limit - expense.alreadySpent;
            }
        }
    }

    /**
    * @dev Helper method to check if a transfer is within the limit.
    * If yes the daily unspent for the current period is updated.
    * @param _wallet The target wallet.
    * @param _amount The amount for the transfer
    */
    function checkAndUpdateDailySpent(BaseWallet _wallet, uint _amount) internal returns (bool) {
        if(_amount == 0) return true;
        Limit storage limit = limits[address(_wallet)].limit;
        uint128 current = currentLimit(limit.current, limit.pending, limit.changeAfter);
        if(isWithinDailyLimit(_wallet, current, _amount)) {
            updateDailySpent(_wallet, current, _amount);
            return true;
        }
        return false;
    }

    /**
    * @dev Helper method to update the daily spent for the current period.
    * @param _wallet The target wallet.
    * @param _limit The current limit for the wallet.
    * @param _amount The amount to add to the daily spent.
    */
    function updateDailySpent(BaseWallet _wallet, uint128 _limit, uint _amount) internal {
        if(_limit != LIMIT_DISABLED) {
            DailySpent storage expense = limits[address(_wallet)].dailySpent;
            // solium-disable-next-line security/no-block-members
            if (expense.periodEnd < now) {
                // solium-disable-next-line security/no-block-members
                expense.periodEnd = uint64(now + 24 hours);
                expense.alreadySpent = uint128(_amount);
            }
            else {
                expense.alreadySpent += uint128(_amount);
            }
        }
    }

    /**
    * @dev Checks if a transfer amount is withing the daily limit for a wallet.
    * @param _wallet The target wallet.
    * @param _limit The current limit for the wallet.
    * @param _amount The transfer amount.
    * @return true if the transfer amount is withing the daily limit.
    */
    function isWithinDailyLimit(BaseWallet _wallet, uint _limit, uint _amount) internal view returns (bool)  {
        if(_limit == LIMIT_DISABLED) {
            return true;
        }
        DailySpent storage expense = limits[address(_wallet)].dailySpent;
        // solium-disable-next-line security/no-block-members
        if (expense.periodEnd < now) {
            return (_amount <= _limit);
        } else {
            return (expense.alreadySpent + _amount <= _limit && expense.alreadySpent + _amount >= expense.alreadySpent);
        }
    }

    /**
    * @dev Helper method to get the current limit from a Limit struct.
    * @param _current The value of the current parameter
    * @param _pending The value of the pending parameter
    * @param _changeAfter The value of the changeAfter parameter
    */
    function currentLimit(uint128 _current, uint128 _pending, uint64 _changeAfter) internal view returns (uint128) {
        // solium-disable-next-line security/no-block-members
        if(_changeAfter > 0 && _changeAfter < now) {
            return _pending;
        }
        return _current;
    }

}

/**
 * @title BaseTransfer
 * @dev Module containing internal methods to execute or approve transfers
 * @author Olivier VDB - <olivier@argent.xyz>
 */
contract BaseTransfer is BaseModule {

    // Mock token address for ETH
    address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    // *************** Events *************************** //

    event Transfer(address indexed wallet, address indexed token, uint256 indexed amount, address to, bytes data);
    event Approved(address indexed wallet, address indexed token, uint256 amount, address spender);
    event CalledContract(address indexed wallet, address indexed to, uint256 amount, bytes data);

    // *************** Internal Functions ********************* //

    /**
    * @dev Helper method to transfer ETH or ERC20 for a wallet.
    * @param _wallet The target wallet.
    * @param _token The ERC20 address.
    * @param _to The recipient.
    * @param _value The amount of ETH to transfer
    * @param _data The data to *log* with the transfer.
    */
    function doTransfer(BaseWallet _wallet, address _token, address _to, uint256 _value, bytes memory _data) internal {
        if(_token == ETH_TOKEN) {
            invokeWallet(address(_wallet), _to, _value, EMPTY_BYTES);
        }
        else {
            bytes memory methodData = abi.encodeWithSignature("transfer(address,uint256)", _to, _value);
            invokeWallet(address(_wallet), _token, 0, methodData);
        }
        emit Transfer(address(_wallet), _token, _value, _to, _data);
    }

    /**
    * @dev Helper method to approve spending the ERC20 of a wallet.
    * @param _wallet The target wallet.
    * @param _token The ERC20 address.
    * @param _spender The spender address.
    * @param _value The amount of token to transfer.
    */
    function doApproveToken(BaseWallet _wallet, address _token, address _spender, uint256 _value) internal {
        bytes memory methodData = abi.encodeWithSignature("approve(address,uint256)", _spender, _value);
        invokeWallet(address(_wallet), _token, 0, methodData);
        emit Approved(address(_wallet), _token, _value, _spender);
    }

    /**
    * @dev Helper method to call an external contract.
    * @param _wallet The target wallet.
    * @param _contract The contract address.
    * @param _value The ETH value to transfer.
    * @param _data The method data.
    */
    function doCallContract(BaseWallet _wallet, address _contract, uint256 _value, bytes memory _data) internal {
        invokeWallet(address(_wallet), _contract, _value, _data);
        emit CalledContract(address(_wallet), _contract, _value, _data);
    }
}

/**
 * @title MakerV2Manager
 * @dev Module to convert SAI <-> DAI and lock/unlock MCD DAI into/from Maker's Pot,
 * @author Olivier VDB - <olivier@argent.xyz>
 */
contract MakerV2Manager is Invest, BaseModule, RelayerModule, OnlyOwnerModule {

    bytes32 constant NAME = "MakerV2Manager";

    // The address of the SAI token
    GemLike public saiToken;
    // The address of the (MCD) DAI token
    GemLike public daiToken;
    // The address of the SAI <-> DAI migration contract
    address public scdMcdMigration;
    // The address of the Pot
    PotLike public pot;
    // The address of the Dai Adapter
    JoinLike public daiJoin;
    // The address of the Vat
    VatLike public vat;

    // Method signatures to reduce gas cost at depoyment
    bytes4 constant internal ERC20_APPROVE = bytes4(keccak256("approve(address,uint256)"));
    bytes4 constant internal SWAP_SAI_DAI = bytes4(keccak256("swapSaiToDai(uint256)"));
    bytes4 constant internal SWAP_DAI_SAI = bytes4(keccak256("swapDaiToSai(uint256)"));
    bytes4 constant internal ADAPTER_JOIN = bytes4(keccak256("join(address,uint256)"));
    bytes4 constant internal ADAPTER_EXIT = bytes4(keccak256("exit(address,uint256)"));
    bytes4 constant internal VAT_HOPE = bytes4(keccak256("hope(address)"));
    bytes4 constant internal POT_JOIN = bytes4(keccak256("join(uint256)"));
    bytes4 constant internal POT_EXIT = bytes4(keccak256("exit(uint256)"));

    uint256 constant internal RAY = 10 ** 27;

    using SafeMath for uint256;

    // ****************** Events *************************** //

    event TokenConverted(address indexed _wallet, address _srcToken, uint _srcAmount, address _destToken, uint _destAmount);

    // *************** Constructor ********************** //

    constructor(
        ModuleRegistry _registry,
        GuardianStorage _guardianStorage,
        ScdMcdMigration _scdMcdMigration,
        PotLike _pot
    )
        BaseModule(_registry, _guardianStorage, NAME)
        public
    {
        scdMcdMigration = address(_scdMcdMigration);
        saiToken = _scdMcdMigration.saiJoin().gem();
        daiJoin = _scdMcdMigration.daiJoin();
        vat = daiJoin.vat();
        daiToken = daiJoin.dai();
        pot = _pot;
    }

    // *************** External/Public Functions ********************* //

    /* ********************************** Implementation of Invest ************************************* */

    /**
     * @dev Invest tokens for a given period.
     * @param _wallet The target wallet.
     * @param _token The token address.
     * @param _amount The amount of tokens to invest.
     * @param _period The period over which the tokens may be locked in the investment (optional).
     * @return The exact amount of tokens that have been invested.
     */
    function addInvestment(
        BaseWallet _wallet,
        address _token,
        uint256 _amount,
        uint256 _period
    )
        external
        returns (uint256 _invested)
    {
        require(_token == address(daiToken), "DM: token should be DAI");
        joinDsr(_wallet, _amount);
        _invested = _amount;
        emit InvestmentAdded(address(_wallet), address(daiToken), _amount, _period);
    }

    /**
     * @dev Exit invested postions.
     * @param _wallet The target wallet.
     * @param _token The token address.
     * @param _fraction The fraction of invested tokens to exit in per 10000.
     */
    function removeInvestment(
        BaseWallet _wallet,
        address _token,
        uint256 _fraction
    )
        external
    {
        require(_token == address(daiToken), "DM: token should be DAI");
        require(_fraction <= 10000, "DM: invalid fraction value");
        exitDsr(_wallet, dsrBalance(_wallet).mul(_fraction) / 10000);
        emit InvestmentRemoved(address(_wallet), _token, _fraction);
    }

    /**
     * @dev Get the amount of investment in a given token.
     * @param _wallet The target wallet.
     * @param _token The token address.
     * @return The value in tokens of the investment (including interests) and the time at which the investment can be removed.
     */
    function getInvestment(
        BaseWallet _wallet,
        address _token
    )
        external
        view
        returns (uint256 _tokenValue, uint256 _periodEnd)
    {
        _tokenValue = _token == address(daiToken) ? dsrBalance(_wallet) : 0;
        _periodEnd = 0;
    }

    /* ****************************************** DSR wrappers ******************************************* */

    function dsrBalance(BaseWallet _wallet) public view returns (uint256) {
        return pot.chi().mul(pot.pie(address(_wallet))) / RAY;
    }

    /**
    * @dev lets the owner deposit MCD DAI into the DSR Pot.
    * @param _wallet The target wallet.
    * @param _amount The amount of DAI to deposit
    */
    function joinDsr(
        BaseWallet _wallet,
        uint256 _amount
    )
        public
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        if (daiToken.balanceOf(address(_wallet)) < _amount) {
            swapSaiToDai(_wallet, _amount - daiToken.balanceOf(address(_wallet)));
        }

        // Execute drip to get the chi rate updated to rho == now, otherwise join will fail
        pot.drip();
        // Approve DAI adapter to take the DAI amount
        invokeWallet(address(_wallet), address(daiToken), 0, abi.encodeWithSelector(ERC20_APPROVE, address(daiJoin), _amount));
        // Join DAI into the vat (_amount of external DAI is burned and the vat transfers _amount of internal DAI from the adapter to the _wallet)
        invokeWallet(address(_wallet), address(daiJoin), 0, abi.encodeWithSelector(ADAPTER_JOIN, address(_wallet), _amount));
        // Approve the pot to take out (internal) DAI from the wallet's balance in the vat
        if (vat.can(address(_wallet), address(pot)) == 0) {
            invokeWallet(address(_wallet), address(vat), 0, abi.encodeWithSelector(VAT_HOPE, address(pot)));
        }
        // Compute the pie value in the pot
        uint256 pie = _amount.mul(RAY) / pot.chi();
        // Join the pie value to the pot
        invokeWallet(address(_wallet), address(pot), 0, abi.encodeWithSelector(POT_JOIN, pie));
    }

    /**
    * @dev lets the owner withdraw MCD DAI from the DSR Pot.
    * @param _wallet The target wallet.
    * @param _amount The amount of DAI to withdraw
    */
    function exitDsr(
        BaseWallet _wallet,
        uint256 _amount
    )
        public
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        // Execute drip to count the savings accumulated until this moment
        pot.drip();
        // Calculates the pie value in the pot equivalent to the DAI wad amount
        uint256 pie = _amount.mul(RAY) / pot.chi();
        // Exit DAI from the pot
        invokeWallet(address(_wallet), address(pot), 0, abi.encodeWithSelector(POT_EXIT, pie));
        // Allow adapter to access the _wallet's DAI balance in the vat
        if (vat.can(address(_wallet), address(daiJoin)) == 0) {
            invokeWallet(address(_wallet), address(vat), 0, abi.encodeWithSelector(VAT_HOPE, address(daiJoin)));
        }
        // Check the actual balance of DAI in the vat after the pot exit
        uint bal = vat.dai(address(_wallet));
        // It is necessary to check if due to rounding the exact _amount can be exited by the adapter.
        // Otherwise it will do the maximum DAI balance in the vat
        uint256 withdrawn = bal >= _amount.mul(RAY) ? _amount : bal / RAY;
        invokeWallet(address(_wallet), address(daiJoin), 0, abi.encodeWithSelector(ADAPTER_EXIT, address(_wallet), withdrawn));
    }

    function exitAllDsr(
        BaseWallet _wallet
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        // Execute drip to count the savings accumulated until this moment
        pot.drip();
        // Gets the total pie belonging to the _wallet
        uint256 pie = pot.pie(address(_wallet));
        // Exit DAI from the pot
        invokeWallet(address(_wallet), address(pot), 0, abi.encodeWithSelector(POT_EXIT, pie));
        // Allow adapter to access the _wallet's DAI balance in the vat
        if (vat.can(address(_wallet), address(daiJoin)) == 0) {
            invokeWallet(address(_wallet), address(vat), 0, abi.encodeWithSelector(VAT_HOPE, address(daiJoin)));
        }
        // Exits the DAI amount corresponding to the value of pie
        uint256 withdrawn = pot.chi().mul(pie) / RAY;
        invokeWallet(address(_wallet), address(daiJoin), 0, abi.encodeWithSelector(ADAPTER_EXIT, address(_wallet), withdrawn));
    }

    /**
    * @dev lets the owner convert SCD SAI into MCD DAI.
    * @param _wallet The target wallet.
    * @param _amount The amount of SAI to convert
    */
    function swapSaiToDai(
        BaseWallet _wallet,
        uint256 _amount
    )
        public
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        require(saiToken.balanceOf(address(_wallet)) >= _amount, "DM: insufficient SAI");
        invokeWallet(address(_wallet), address(saiToken), 0, abi.encodeWithSelector(ERC20_APPROVE, scdMcdMigration, _amount));
        invokeWallet(address(_wallet), scdMcdMigration, 0, abi.encodeWithSelector(SWAP_SAI_DAI, _amount));
        emit TokenConverted(address(_wallet), address(saiToken), _amount, address(daiToken), _amount);
    }

    /**
    * @dev lets the owner convert MCD DAI into SCD SAI.
    * @param _wallet The target wallet.
    * @param _amount The amount of DAI to convert
    */
    function swapDaiToSai(
        BaseWallet _wallet,
        uint256 _amount
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        require(daiToken.balanceOf(address(_wallet)) >= _amount, "DM: insufficient DAI");
        invokeWallet(address(_wallet), address(daiToken), 0, abi.encodeWithSelector(ERC20_APPROVE, scdMcdMigration, _amount));
        invokeWallet(address(_wallet), scdMcdMigration, 0, abi.encodeWithSelector(SWAP_DAI_SAI, _amount));
        emit TokenConverted(address(_wallet), address(daiToken), _amount, address(saiToken), _amount);
    }
}