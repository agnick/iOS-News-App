//
//  UIColor+Extensions.swift
//  nmagafonovPW4
//
//  Created by Никита Агафонов on 03.12.2024.
//

import UIKit

// MARK: - Color methods
extension UIColor {
    // MARK: - Enums
    enum Constants {
        // Strings
        static let startSymb: String = "#"
        
        // Hex settings
        static let hexLength: UInt64 = 6
        static let maxColorValue: CGFloat = 255
        static let redBinmove: UInt64 = 16
        static let greenBinmove: UInt64 = 8
        static let redMask: UInt64 = 0xFF0000
        static let greenMask: UInt64 = 0x00FF00
        static let blueMask: UInt64 = 0x0000FF
    }
    
    // MARK: - Lifecycle
    // Вспомогательный конструктор, чтобы добавить возможность инициализировать UIColor с hex.
    convenience init?(hex: String) {
        // Инициализация rgb переменных в диапазоне от 0 до 1.
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        
        // Проверка, что hex начинается с символа '#'.
        if hex.hasPrefix(Constants.startSymb) {
            // Смещаем указатель на 1, чтобы взять нужную часть.
            let idx: String.Index = hex.index(hex.startIndex, offsetBy: 1)
            // Обрезаем hex
            let hexColor: String = String(hex[idx...])
            
            // Проверяем что hex содержит верное кол-во символом.
            if hexColor.count == Constants.hexLength {
                // Инициализируем Scanner, чтобы конвертировать строку в число.
                let scanner = Scanner(string: hexColor)
                var hexNum: UInt64 = 0;
                
                // Проверяем что преобразование прошло успешно и сохраняем значение в hexNum.
                if scanner.scanHexInt64(&hexNum) {
                    // Извлечение первых 2 цифр, используя маску и побитовый сдвиг на 16 битов, нормализация значения
                    r = CGFloat((hexNum & Constants.redMask) >> Constants.redBinmove) / Constants.maxColorValue
                    g = CGFloat((hexNum & Constants.greenMask) >> Constants.greenBinmove) / Constants.maxColorValue
                    b = CGFloat(hexNum & Constants.blueMask) / Constants.maxColorValue
                    
                    // Вызов основого конструктура UIСolor
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    
                    return
                }
            }
        }
        
        // Если что-то пошло не так...
        return nil
    }
}
