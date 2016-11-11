module ConfigBot
    class Common
        TYPES = %w{ask mask yes? select multi_select enum_select multiline}
        CONVERTS = %w{bool date datetime file float int path range regexp string symbol}
    end
end
