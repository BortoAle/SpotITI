//
//  QRScannerView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI

struct QRScannerView: View {
	@StateObject var qrCodeScanner = QRCodeScanner()

	var body: some View {
			ZStack {
				CameraPreviewView(session: qrCodeScanner.session) // Aggiungi la vista della fotocamera
					.clipShape(RoundedRectangle(cornerRadius: 25))
					.shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
				Text("Valore QR Code: \(qrCodeScanner.qrCodeValue)")
					.padding()
			}
			.padding()
			
		.onAppear { qrCodeScanner.startScanning() }
		.onDisappear { qrCodeScanner.stopScanning() }
	}
}


struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRScannerView()
    }
}
