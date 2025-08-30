//
//  NewJournalEntryView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct NewJournalEntryView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPrompt: String = ""
    @State private var customPrompt: String = ""
    @State private var response: String = ""
    @State private var selectedMood: MoodType = .nileCalm
    @State private var showMoodPicker = false
    @State private var isUsingCustomPrompt = false
    
    private let journalPrompts = [
        "What wisdom did I gain today, like the ancient pharaohs?",
        "How can I build my inner pyramid of strength?",
        "What would the gods of Egypt teach me about this challenge?",
        "Like the Nile's flow, how can I adapt to change?",
        "What treasures of knowledge did I discover today?",
        "How did I show resilience like the eternal pyramids?",
        "What creative inspiration flowed through me like the Nile?",
        "How can I honor my ancestors' wisdom in my actions?",
        "What sacred knowledge am I ready to receive?",
        "How did I practice patience like the desert sands?"
    ]
    
    var finalPrompt: String {
        isUsingCustomPrompt ? customPrompt : selectedPrompt
    }
    
    var canSave: Bool {
        !finalPrompt.isEmpty && !response.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        EgyptianColors.papyrus,
                        EgyptianColors.desertSand.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        headerView
                        
                        // Prompt selection
                        promptSelectionView
                        
                        // Mood selection
                        moodSelectionView
                        
                        // Response area
                        responseView
                        
                        // Save button
                        saveButtonView
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            selectedPrompt = journalPrompts.randomElement() ?? journalPrompts[0]
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(EgyptianColors.textDark.opacity(0.6))
                
                Spacer()
                
                Text("New Journal Entry")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                
                Spacer()
                
                Button("Save") {
                    saveEntry()
                }
                .foregroundColor(canSave ? EgyptianColors.golden : EgyptianColors.textDark.opacity(0.3))
                .disabled(!canSave)
            }
            
            // Papyrus decoration
            HStack {
                decorativeDivider
                
                Text(EgyptianSymbols.papyrus)
                    .font(.system(size: 24))
                    .foregroundColor(EgyptianColors.golden)
                
                decorativeDivider
            }
        }
    }
    
    @ViewBuilder
    private var decorativeDivider: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.clear,
                        EgyptianColors.golden.opacity(0.5),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 1)
    }
    
    @ViewBuilder
    private var promptSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Your Reflection")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            // Toggle between preset and custom
            HStack {
                Button(action: {
                    isUsingCustomPrompt = false
                }) {
                    HStack {
                        Image(systemName: isUsingCustomPrompt ? "circle" : "circle.fill")
                        Text("Guided Prompt")
                    }
                    .font(EgyptianFonts.body())
                    .foregroundColor(isUsingCustomPrompt ? EgyptianColors.textDark.opacity(0.6) : EgyptianColors.golden)
                }
                
                Spacer()
                
                Button(action: {
                    isUsingCustomPrompt = true
                }) {
                    HStack {
                        Image(systemName: isUsingCustomPrompt ? "circle.fill" : "circle")
                        Text("Custom Prompt")
                    }
                    .font(EgyptianFonts.body())
                    .foregroundColor(isUsingCustomPrompt ? EgyptianColors.golden : EgyptianColors.textDark.opacity(0.6))
                }
            }
            
            if isUsingCustomPrompt {
                // Custom prompt input
                TextField("Write your own reflection prompt...", text: $customPrompt)
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textDark)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(EgyptianColors.papyrus)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(EgyptianColors.golden.opacity(0.3), lineWidth: 1)
                            )
                    )
            } else {
                // Preset prompts
                VStack(spacing: 12) {
                    ForEach(journalPrompts.prefix(3), id: \.self) { prompt in
                        promptButton(prompt: prompt)
                    }
                    
                    Button("More Prompts...") {
                        selectedPrompt = journalPrompts.randomElement() ?? journalPrompts[0]
                    }
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.golden)
                    .padding(.top, 8)
                }
            }
            
            // Selected/current prompt display
            if !finalPrompt.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Prompt:")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textDark.opacity(0.7))
                    
                    Text(finalPrompt)
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.textDark)
                        .italic()
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(EgyptianColors.golden.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(EgyptianColors.golden.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .egyptianCard()
    }
    
    private func promptButton(prompt: String) -> some View {
        Button(action: {
            selectedPrompt = prompt
        }) {
            HStack {
                Text(EgyptianSymbols.papyrus)
                    .font(.system(size: 16))
                    .foregroundColor(EgyptianColors.golden)
                
                Text(prompt)
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textDark)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if selectedPrompt == prompt {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(EgyptianColors.turquoise)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        selectedPrompt == prompt ? 
                        EgyptianColors.golden.opacity(0.1) : 
                        EgyptianColors.papyrus.opacity(0.5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                selectedPrompt == prompt ? 
                                EgyptianColors.golden.opacity(0.5) : 
                                Color.clear,
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var moodSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How Are You Feeling?")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            // Current mood display
            Button(action: {
                showMoodPicker.toggle()
            }) {
                HStack {
                    Text(selectedMood.emoji)
                        .font(.system(size: 24))
                    
                    Text(selectedMood.rawValue)
                        .font(EgyptianFonts.body())
                        .foregroundColor(selectedMood.color)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(EgyptianColors.textDark.opacity(0.6))
                        .rotationEffect(.degrees(showMoodPicker ? 180 : 0))
                        .animation(.easeInOut(duration: 0.3), value: showMoodPicker)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedMood.color.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedMood.color.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Mood picker
            if showMoodPicker {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(MoodType.allCases, id: \.self) { mood in
                        moodButton(mood: mood)
                    }
                }
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut(duration: 0.3), value: showMoodPicker)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .egyptianCard()
    }
    
    private func moodButton(mood: MoodType) -> some View {
        Button(action: {
            selectedMood = mood
            showMoodPicker = false
        }) {
            VStack(spacing: 8) {
                Text(mood.emoji)
                    .font(.system(size: 30))
                
                Text(mood.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(mood.color)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(mood.color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                selectedMood == mood ? 
                                mood.color : 
                                mood.color.opacity(0.3),
                                lineWidth: selectedMood == mood ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var responseView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Reflection")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            ZStack(alignment: .topLeading) {
                if response.isEmpty {
                    Text("Write your thoughts and reflections here, like the ancient scribes recorded their wisdom on papyrus...")
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.textDark.opacity(0.5))
                        .padding(16)
                }
                
                TextEditor(text: $response)
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textDark)
                    .padding(12)
                    .background(Color.clear)
            }
            .frame(minHeight: 200)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(EgyptianColors.papyrus)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(EgyptianColors.golden.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .egyptianCard()
    }
    
    @ViewBuilder
    private var saveButtonView: some View {
        VStack(spacing: 16) {
            Button("Save Entry") {
                saveEntry()
            }
            .egyptianButton()
            .disabled(!canSave)
            
            Button("Cancel") {
                dismiss()
            }
            .egyptianButton(secondary: true)
        }
    }
    
    private func saveEntry() {
        guard canSave else { return }
        
        let entry = JournalEntry(
            date: Date(),
            prompt: finalPrompt,
            response: response,
            mood: selectedMood
        )
        
        appState.addJournalEntry(entry)
        dismiss()
    }
}

#Preview {
    NewJournalEntryView()
        .environmentObject(AppState())
}
