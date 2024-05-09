pragma solidity ^0.5.2;

contract IDFEngine {
    function disableOwnership() public;
    function transferOwnership(address newOwner_) public;
    function acceptOwnership() public;
    function setAuthority(address authority_) public;
    function deposit(address _sender, address _tokenID, uint _feeTokenIdx, uint _amount) public returns (uint);
    function withdraw(address _sender, address _tokenID, uint _feeTokenIdx, uint _amount) public returns (uint);
    function destroy(address _sender, uint _feeTokenIdx, uint _amount) public returns (bool);
    function claim(address _sender, uint _feeTokenIdx) public returns (uint);
    function oneClickMinting(address _sender, uint _feeTokenIdx, uint _amount) public;
}

contract DSAuthority {
    function canCall(
        address src, address dst, bytes4 sig
    ) public view returns (bool);
}

contract DSAuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
    event OwnerUpdate     (address indexed owner, address indexed newOwner);
}

contract DSAuth is DSAuthEvents {
    DSAuthority  public  authority;
    address      public  owner;
    address      public  newOwner;

    constructor() public {
        owner = msg.sender;
        emit LogSetOwner(msg.sender);
    }

    // Warning: you should absolutely sure you want to give up authority!!!
    function disableOwnership() public onlyOwner {
        owner = address(0);
        emit OwnerUpdate(msg.sender, owner);
    }

    function transferOwnership(address newOwner_) public onlyOwner {
        require(newOwner_ != owner, "TransferOwnership: the same owner.");
        newOwner = newOwner_;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner, "AcceptOwnership: only new owner do this.");
        emit OwnerUpdate(owner, newOwner);
        owner = newOwner;
        newOwner = address(0x0);
    }

    ///[snow] guard is Authority who inherit DSAuth.
    function setAuthority(DSAuthority authority_)
        public
        onlyOwner
    {
        authority = authority_;
        emit LogSetAuthority(address(authority));
    }

    modifier onlyOwner {
        require(isOwner(msg.sender), "ds-auth-non-owner");
        _;
    }

    function isOwner(address src) internal view returns (bool) {
        return bool(src == owner);
    }

    modifier auth {
        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == DSAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, address(this), sig);
        }
    }
}

contract DFUpgrader is DSAuth {

    // MEMBERS
    // @dev  The reference to the active converter implementation.
    IDFEngine public iDFEngine;

    /// @dev  The map of lock ids to pending implementation changes.
    address newDFEngine;

    // CONSTRUCTOR
    constructor () public {
        iDFEngine = IDFEngine(0x0);
    }

    // PUBLIC FUNCTIONS
    // (UPGRADE)
    /** @notice  Requests a change of the active implementation associated
      * with this contract.
      *
      * @dev  Anyone can call this function, but confirming the request is authorized
      * by the custodian.
      *
      * @param  _newDFEngine  The address of the new active implementation.
      */
    function requestImplChange(address _newDFEngine) public onlyOwner {
        require(_newDFEngine != address(0), "_newDFEngine: The address is empty");

        newDFEngine = _newDFEngine;

        emit ImplChangeRequested(msg.sender, _newDFEngine);
    }

    /** @notice  Confirms a pending change of the active implementation
      * associated with this contract.
      *
      * @dev  the `Converter ConverterImpl` member will be updated
      * with the requested address.
      *
      */
    function confirmImplChange() public onlyOwner {
        iDFEngine = IDFEngine(newDFEngine);

        emit ImplChangeConfirmed(address(iDFEngine));
    }

    /// @dev  Emitted by successful `requestImplChange` calls.
    event ImplChangeRequested(address indexed _msgSender, address indexed _proposedImpl);

    /// @dev Emitted by successful `confirmImplChange` calls.
    event ImplChangeConfirmed(address indexed _newImpl);
}

contract DFProtocol is DFUpgrader {
    /******************************************/
    /* Public events that will notify clients */
    /******************************************/

    /**
     * @dev Emmit when `_tokenAmount` tokens of `_tokenID` deposits from one account(`_sender`),
     * and show the amout(`_usdxAmount`) tokens generate.
     */
    event Deposit (address indexed _tokenID, address indexed _sender, uint _tokenAmount, uint _usdxAmount);

    /**
     * @dev Emmit when `_expectedAmount` tokens of `_tokenID` withdraws from one account(`_sender`),
     * and show the amount(`_actualAmount`) tokens have been withdrawed successfully.
     *
     * Note that `_actualAmount` may be less than or equal to `_expectedAmount`.
     */
    event Withdraw(address indexed _tokenID, address indexed _sender, uint _expectedAmount, uint _actualAmount);

    /**
     * @dev Emmit when `_amount` USDx were destroied from one account(`_sender`).
     */
    event Destroy (address indexed _sender, uint _usdxAmount);

    /**
     * @dev Emmit when `_usdxAmount` USDx were claimed from one account(`_sender`).
     */
    event Claim(address indexed _sender, uint _usdxAmount);

    /**
     * @dev Emmit when `_amount` USDx were minted from one account(`_sender`).
     */
    event OneClickMinting(address indexed _sender, uint _usdxAmount);

    /******************************************/
    /*            User interfaces             */
    /******************************************/

    /**
     * @dev The caller deposits `_tokenAmount` tokens of `_tokenID`,
     * and the caller would like to use `_feeTokenIdx` as the transaction fee.
     *
     * Note that: 1)For `_tokenID`: it should be one of the supported stabel currencies.
     *            2)For `_feeTokenIdx`: 0 is DF, and 1 is USDx.
     *
     * Returns a uint value indicating the total amount that generating USDx.
     *
     * Emits a `Deposit` event.
     */
    function deposit(address _tokenID, uint _feeTokenIdx, uint _tokenAmount) public returns (uint){
        uint _usdxAmount = iDFEngine.deposit(msg.sender, _tokenID, _feeTokenIdx, _tokenAmount);
        emit Deposit(_tokenID, msg.sender, _tokenAmount, _usdxAmount);
        return _usdxAmount;
    }

    /**
     * @dev The caller withdraws `_expectedAmount` tokens of `_tokenID`,
     * and the caller would like to use `_feeTokenIdx` as the transaction fee.
     *
     * Returns a uint value indicating the total amount of the caller has withdrawed successfully.
     *
     * Emits a `Withdraw` event.
     */
    function withdraw(address _tokenID, uint _feeTokenIdx, uint _expectedAmount) public returns (uint) {
        uint _actualAmount = iDFEngine.withdraw(msg.sender, _tokenID, _feeTokenIdx, _expectedAmount);
        emit Withdraw(_tokenID, msg.sender, _expectedAmount, _actualAmount);
        return _actualAmount;
    }

    /**
     * @dev The caller destroies `_usdxAmount` USDx,
     * and the caller would like to use `_feeTokenIdx` as the transaction fee.
     *
     * Emits a `Destroy` event.
     */
    function destroy(uint _feeTokenIdx, uint _usdxAmount) public {
        iDFEngine.destroy(msg.sender, _feeTokenIdx, _usdxAmount);
        emit Destroy(msg.sender, _usdxAmount);
    }

    /**
     * @dev The caller claims to get spare USDx he can get,
     * and the caller would like to use `_feeTokenIdx` as the transaction fee.
     *
     * Returns a uint value indicating the total amount of the caller has claimed.
     *
     * Emits a `Claim` event.
     */
    function claim(uint _feeTokenIdx) public returns (uint) {
        uint _usdxAmount = iDFEngine.claim(msg.sender, _feeTokenIdx);
        emit Claim(msg.sender, _usdxAmount);
        return _usdxAmount;
    }

    /**
     * @dev The caller mints `_usdxAmount` USDx directly,
     * and the caller would like to use `_feeTokenIdx` as the transaction fee.
     *
     * Emits a `OneClickMinting` event.
     */
    function oneClickMinting(uint _feeTokenIdx, uint _usdxAmount) public {
        iDFEngine.oneClickMinting(msg.sender, _feeTokenIdx, _usdxAmount);
        emit OneClickMinting(msg.sender, _usdxAmount);
    }
}