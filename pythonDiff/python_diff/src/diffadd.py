#!/usr/bin/env python
# coding:utf-8
## 標準モジュールのインポート
# 時刻表示
import datetime
## 差分比較ライブラリー
import difflib
## 文字全角半角変換
import unicodedata
## CSVモジュール
import csv

def readCSV(filename: str) -> list:
    ''' CSVファイル読み込み'''
    with open(filename) as f:
        return [row for row in csv.DictReader(f)]

def writerCSV(filename: str,data: list, header: list):
    ''' CSVファイル書き込み ヘッダー指定'''
    with open(filename, 'w') as f:
        writer = csv.DictWriter(f, header)
        writer.writeheader()
        writer.writerows(data)

def nowdate() -> str:
    ''' 現在時刻表示文字列 RFC3339 +9H'''
    return datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%f+09:00")

def Similar(str1 :str, str2: str) -> float:
    '''文字列同士の類似度を比較'''
    return difflib.SequenceMatcher(None, str1, str2).ratio()

def masterMatch(matchString: str, master: list):
    '''データをマスタとの比較 キーワード同士の類似度を比較 '''
    resultList = []
    for rowMaster in master:
        rowMaster.update({'Similar': Similar(matchString, rowMaster["Name"])})
        resultList.append(rowMaster)

    # リスト内の辞書のうち、'Similar'の値で並び替える
    #インデックス 0 から 2 までの要素を取得する
    return sorted(resultList, key=lambda x:x['Similar'],reverse=True)[0:1]
    #return [ x.update({'Similar': Similar(matchString, x["Name"])}) for x in master]


def main():
    print(f'{nowdate()}, Read CSV, Info')

    # マスターデータ読み込み
    master = readCSV(filename="./Master.csv")
    # 検索データ読み込み
    infoData = readCSV(filename="./infoData.csv")

    print(f'{nowdate()}, Diff, Info')

    # 比較
    resultList = []
    for rowinfoData in infoData:
        Similaradd = masterMatch(matchString=rowinfoData["CompanyName"], master=master)
        # 検索行と最も類似度の高いマスターと結合
        rowinfoData.update(Similaradd[0])
        resultList.append(rowinfoData)
        print(f'{nowdate()}, {rowinfoData["CompanyName"]}, Info')

    # 　マッチングデータ書き込み
    print(f'{nowdate()}, Writer CSV, Info')
    writerCSV(filename='Similar.csv',data=resultList, header=["Email", "CompanyName", "Name", "Similar", "Code", "id", "Similar", "subcode", "Number", "Tell"])

if __name__ == '__main__':
    main()

