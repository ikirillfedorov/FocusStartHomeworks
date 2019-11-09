//
//  Calculator.swift
//  Homework2
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

// ЗАДАНИЕ:
// Сделать расширение класса String c 2 методами:
// 1. Метод возвращает строку с развернутыми словам.
// Порядок слов не меняется, меняется порядок букв в словах.
// Пример: "hello world" -> "olleh dlrow"
// Сигнатура метода: .reversedWords() -> String

// 2. Метод проверяет номер мобильного телефона на правильность.
// Коды русских номеров телефонов - 900...999, номер может начинаться
// с '+7', '7' и '8'. Номер можно вводить и со скобками и с черточками
// и пробелами.
// Сигнатура метода: .validate() -> Bool
import Foundation

extension String
{
	func reversedWords() -> String {
		return self
			.components(separatedBy: " ")
			.map { String($0.reversed()) }
			.joined(separator: " ")
	}

	func validate() -> Bool {
		let regex = "^(\\+7|7|8)+" +
					"[ \\-]?\\(?[9][0-9]{2}\\)?" +
					"[ \\-]?[0-9]{3}" +
					"[ \\-]?[0-9]{2}" +
					"[ \\-]?[0-9]{2}$"
		return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
	}
}
