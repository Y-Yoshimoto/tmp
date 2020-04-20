## アクション ディスカバリーに対応するルールを作る
イベントソースをディスカバリーに設定しアクションを追加する
アクション受信したデータ修正→含む

アクション

Linux Server自動登録	受信した値 含む Linux
    アップタイム/ダウンタイム 以上 600
    ディスカバリのステータス 等しい Up
    サービスのタイプ 等しい Zabbixエージェント
    ホストを追加
    ホストグループに追加: 
    テンプレートとリンク: Linux Server テンプレート(CentOS8)

Windows Server自動登録	受信した値 含む Windows
    アップタイム/ダウンタイム 以上 600
    ディスカバリのステータス 等しい Up
    サービスのタイプ 等しい Zabbixエージェント
    ホストを追加
    ホストグループに追加:
    テンプレートとリンク: Windows Server テンプレート(2019)

ディスカバリルール
    名前
    IPアドレス範囲指定
    監視間隔 1h
    チェック
        Zabbixエージェント "system.hostname"
        Zabbixエージェント "system.uname"
    デバイスの固有性を特定する基準
        Zabbixエージェント "system.hostname"
ホスト名
        Zabbixエージェント "system.hostname"
表示名
        Zabbixエージェント "system.hostname"
